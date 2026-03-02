import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../db_frame_elevate/data.dart';
import '../../utils/index.dart';
import '../frame_elevate_gallery/frame_elevate_gallery_logic.dart';
class FrameElevateSettingsLogic extends GetxController {
  final artworkCount = 0.obs;
  final storageMB = 0.0.obs;
  final storagePercentage = 0.0.obs;
  @override
  void onInit() {
    super.onInit();
    loadStorageInfo();
  }
  Future<void> loadStorageInfo() async {
    try {
      final artworks = await FrameElevateDB.to.getArtworks();
      artworkCount.value = artworks.length;
      double totalBytes = 0;
      for (final artwork in artworks) {
        try {
          final thumbnailFile = File(artwork.thumbnailPath);
          if (await thumbnailFile.exists()) {
            final thumbnailSize = await thumbnailFile.length();
            totalBytes += thumbnailSize;
          }
          final outputFile = File(artwork.outputPath);
          if (await outputFile.exists()) {
            final outputSize = await outputFile.length();
            totalBytes += outputSize;
          }
        } catch (e) {
        }
      }
      storageMB.value = (totalBytes / (1024 * 1024) * 100).round() / 100;
      final maxStorageGB = 1.0;
      final usedGB = totalBytes / (1024 * 1024 * 1024);
      storagePercentage.value = (usedGB / maxStorageGB * 100).clamp(0.0, 100.0);
    } catch (e) {
      errorToast('Failed to load storage info');
    }
  }
  Future<void> onClearData() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all history records and cached files. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirm'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (confirmed != true) return;
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFFC9A96E)),
        ),
        barrierDismissible: false,
      );
      final artworks = await FrameElevateDB.to.getArtworks();
      if (artworks.isEmpty) {
        Get.back();
        successToast('No data to clear');
        return;
      }
      for (final artwork in artworks) {
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
      await FrameElevateDB.to.deleteAllArtworks();
      try {
        final tempDir = await getTemporaryDirectory();
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
          await tempDir.create();
        }
      } catch (e) {
      }
      Get.back();
      await loadStorageInfo();
      try {
        final galleryLogic = Get.find<FrameElevateGalleryLogic>();
        await galleryLogic.loadArtworks();
      } catch (e) {
      }
      successToast('Data cleared successfully');
    } catch (e) {
      Get.back();
      errorToast('Failed to clear data, please try again');
    }
  }
  Future<void> onRateApp() async {
    errorToast('Rate feature coming soon');
  }
  Future<void> onPrivacyPolicy() async {
    errorToast('Privacy policy coming soon');
  }
}
