import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../db_frame_elevate/data.dart';
import '../../db_frame_elevate/db_frame_elevate_entity.dart';
import '../../utils/index.dart';
import '../frame_elevate_gallery/frame_elevate_gallery_logic.dart';
class FrameElevateGalleryPreviewLogic extends GetxController {
  final currentIndex = 0.obs;
  final artworks = <ArtworkEntity>[].obs;
  int get total => artworks.length;
  ArtworkEntity? get currentArtwork {
    if (currentIndex.value >= 0 && currentIndex.value < artworks.length) {
      return artworks[currentIndex.value];
    }
    return null;
  }
  @override
  void onInit() {
    super.onInit();
    _loadArtworks();
  }
  Future<void> _loadArtworks() async {
    try {
      final list = await FrameElevateDB.to.getArtworks();
      artworks.value = list;
      final args = Get.arguments;
      if (args != null && args['index'] != null) {
        currentIndex.value = args['index'] as int;
      }
    } catch (e) {
      errorToast('Failed to load artworks');
      Get.back();
    }
  }
  void onPrevious() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
  void onNext() {
    if (currentIndex.value < total - 1) {
      currentIndex.value++;
    }
  }
  void onMoreTap() {
    Get.bottomSheet(
      _buildMoreMenu(),
      backgroundColor: Colors.transparent,
    );
  }
  Widget _buildMoreMenu() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuItem(
              icon: Icons.info_outline,
              label: 'Details',
              onTap: onShowDetails,
            ),
            const Divider(color: Color(0xFF333333), height: 1),
            _buildMenuItem(
              icon: Icons.delete_outline,
              label: 'Delete',
              color: const Color(0xFFE05555),
              onTap: deleteArtwork,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFAAAAAA)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        label,
        style: TextStyle(color: color ?? Colors.white),
      ),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
  Future<void> onReEdit() async {
    final artwork = currentArtwork;
    if (artwork == null) return;
    errorToast('Re-edit feature coming soon');
  }
  Future<void> onSave() async {
    final artwork = currentArtwork;
    if (artwork == null) return;
    try {
      final hasPermission = await _checkStoragePermission();
      if (!hasPermission) {
        errorToast('Storage permission denied');
        return;
      }
      final outputFile = File(artwork.outputPath);
      if (!await outputFile.exists()) {
        errorToast('File not found');
        return;
      }
      await Gal.putImage(artwork.outputPath);
      successToast('Saved to gallery');
    } catch (e) {
      errorToast('Failed to save: ${e.toString()}');
    }
  }
  Future<bool> _checkStoragePermission() async {
    if (Platform.isIOS) {
      return true;
    }
    if (Platform.isAndroid) {
      final status = await Permission.photos.status;
      if (status.isGranted) {
        return true;
      }
      final result = await Permission.photos.request();
      if (result.isGranted) {
        return true;
      }
      if (result.isPermanentlyDenied) {
        final shouldOpen = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Storage permission is required to save images. Please grant permission in Settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        if (shouldOpen == true) {
          await openAppSettings();
        }
      }
      return false;
    }
    return false;
  }
  Future<void> deleteArtwork() async {
    final artwork = currentArtwork;
    if (artwork == null || artwork.id == null) return;
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Artwork'),
        content: const Text(
          'Are you sure you want to delete this artwork? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed != true) return;
    try {
      await FrameElevateDB.to.deleteArtwork(artwork.id!);
      try {
        final thumbnailFile = File(artwork.thumbnailPath);
        if (await thumbnailFile.exists()) {
          await thumbnailFile.delete();
        }
        final outputFile = File(artwork.outputPath);
        if (await outputFile.exists()) {
          await outputFile.delete();
        }
      } catch (e) {
      }
      successToast('Artwork deleted');
      final galleryLogic = Get.find<FrameElevateGalleryLogic>();
      await galleryLogic.loadArtworks();
      Get.back();
    } catch (e) {
      errorToast('Failed to delete artwork');
    }
  }
  Future<void> onShowDetails() async {
    final artwork = currentArtwork;
    if (artwork == null) return;
    Get.dialog(
      AlertDialog(
        title: const Text('Artwork Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', _getFeatureTypeLabel(artwork.featureType)),
            _buildDetailRow('Created', artwork.createdAt),
            _buildDetailRow('Path', artwork.outputPath),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
  String _getFeatureTypeLabel(String featureType) {
    switch (featureType) {
      case 'single':
        return 'Single Frame';
      case 'batch':
        return 'Batch Frame';
      case 'combo':
        return 'Combo Frame';
      case 'photo':
        return 'Scan & Frame';
      default:
        return 'Single Frame';
    }
  }
}
