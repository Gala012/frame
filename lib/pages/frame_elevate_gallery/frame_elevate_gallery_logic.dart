import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_frame_elevate/data.dart';
import '../../db_frame_elevate/db_frame_elevate_entity.dart';
import '../../utils/index.dart';
class FrameElevateGalleryLogic extends GetxController {
  final artworks = <ArtworkEntity>[].obs;
  final isSelectMode = false.obs;
  final selectedIds = <int>[].obs;
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadArtworks();
  }
  Future<void> loadArtworks() async {
    try {
      isLoading.value = true;
      final list = await FrameElevateDB.to.getArtworks();
      artworks.value = list;
    } catch (e) {
      errorToast('Failed to load artworks');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> onRefresh() async {
    await loadArtworks();
  }
  void onPreviewTap(int index) {
    if (isSelectMode.value) {
      onToggleSelect(index);
    } else {
      Get.toNamed(
        '/gallery/preview',
        arguments: {'index': index},
      );
    }
  }
  void onToggleSelectMode() {
    isSelectMode.value = !isSelectMode.value;
    if (!isSelectMode.value) {
      selectedIds.clear();
    }
  }
  void onToggleSelect(int index) {
    final artwork = artworks[index];
    if (artwork.id == null) return;
    if (selectedIds.contains(artwork.id)) {
      selectedIds.remove(artwork.id);
    } else {
      selectedIds.add(artwork.id!);
    }
  }
  Future<void> onDeleteSelected() async {
    if (selectedIds.isEmpty) {
      errorToast('Please select at least one artwork');
      return;
    }
    final confirmed = await Get.dialog<bool>(
      _buildDeleteConfirmDialog(),
      barrierDismissible: false,
    );
    if (confirmed != true) return;
    try {
      for (final id in selectedIds) {
        final artwork = artworks.firstWhereOrNull((a) => a.id == id);
        if (artwork != null) {
          await FrameElevateDB.to.deleteArtwork(id);
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
        }
      }
      successToast('${selectedIds.length} artworks deleted');
      selectedIds.clear();
      isSelectMode.value = false;
      await loadArtworks();
    } catch (e) {
      errorToast('Failed to delete artworks');
    }
  }
  Widget _buildDeleteConfirmDialog() {
    return AlertDialog(
      title: const Text('Delete Artworks'),
      content: Text(
        'Are you sure you want to delete ${selectedIds.length} selected artwork(s)? This action cannot be undone.',
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
    );
  }
  String getFeatureTypeLabel(String featureType) {
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
