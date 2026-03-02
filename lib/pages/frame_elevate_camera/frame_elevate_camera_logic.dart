import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/image_processor.dart';
class FrameElevateCameraLogic extends GetxController {
  CameraController? cameraController;
  final hasPhoto = false.obs;
  final flashMode = 0.obs;
  final isCameraInitialized = false.obs;
  final isCapturing = false.obs;
  XFile? capturedImage;
  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }
  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(
          msg: 'Camera permission is required. Please enable it in Settings.',
          backgroundColor: const Color(0xFFFF6B6B),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        return;
      }
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Fluttertoast.showToast(
          msg: 'No camera available on this device',
          backgroundColor: const Color(0xFFFF6B6B),
          textColor: Colors.white,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        return;
      }
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await cameraController!.initialize();
      await _updateFlashMode();
      isCameraInitialized.value = true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Camera initialization failed. Please try again.',
        backgroundColor: const Color(0xFFFF6B6B),
        textColor: Colors.white,
      );
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    }
  }
  Future<void> _updateFlashMode() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    try {
      switch (flashMode.value) {
        case 0:
          await cameraController!.setFlashMode(FlashMode.off);
          break;
        case 1:
          await cameraController!.setFlashMode(FlashMode.auto);
          break;
        case 2:
          await cameraController!.setFlashMode(FlashMode.always);
          break;
      }
    } catch (e) {
    }
  }
  Future<void> onCaptureTap() async {
    if (isCapturing.value ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return;
    }
    try {
      isCapturing.value = true;
      capturedImage = await cameraController!.takePicture();
      hasPhoto.value = true;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to capture photo',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isCapturing.value = false;
    }
  }
  void onRetakeTap() {
    hasPhoto.value = false;
    capturedImage = null;
  }
  Future<void> onUsePhotoTap() async {
    if (capturedImage == null) {
      Fluttertoast.showToast(
        msg: 'No photo captured',
        backgroundColor: const Color(0xFFFF6B6B),
        textColor: Colors.white,
      );
      return;
    }
    try {
      debugPrint('📸 Starting photo processing...');
      debugPrint('📸 Original path: ${capturedImage!.path}');
      final originalFile = File(capturedImage!.path);
      if (!await originalFile.exists()) {
        debugPrint('❌ Original file does not exist!');
        Fluttertoast.showToast(
          msg: 'Photo file not found',
          backgroundColor: const Color(0xFFFF6B6B),
          textColor: Colors.white,
        );
        return;
      }
      debugPrint('✅ Original file exists, size: ${await originalFile.length()} bytes');
      final compressedFile = await ImageProcessor.compressImage(
        imageFile: originalFile,
        maxWidth: 2048,
        maxHeight: 2048,
        quality: 90,
      );
      if (compressedFile == null) {
        debugPrint('❌ Compression failed!');
        Fluttertoast.showToast(
          msg: 'Failed to process photo',
          backgroundColor: const Color(0xFFFF6B6B),
          textColor: Colors.white,
        );
        return;
      }
      debugPrint('✅ Compressed file: ${compressedFile.path}');
      debugPrint('✅ Compressed size: ${await compressedFile.length()} bytes');
      debugPrint('🚀 Navigating to crop page...');
      Get.toNamed('/photo-frame/crop',
          arguments: {'photoPath': compressedFile.path});
    } catch (e) {
      debugPrint('❌ Error in onUsePhotoTap: $e');
      Fluttertoast.showToast(
        msg: 'Failed to process photo: ${e.toString()}',
        backgroundColor: const Color(0xFFFF6B6B),
        textColor: Colors.white,
      );
    }
  }
  Future<void> onFlashToggle() async {
    flashMode.value = (flashMode.value + 1) % 3;
    await _updateFlashMode();
  }
  void onAlbumTap() {
    Get.toNamed('/single-frame/pick');
  }
  IconData get flashIcon {
    switch (flashMode.value) {
      case 1:
        return Icons.flash_auto;
      case 2:
        return Icons.flash_on;
      default:
        return Icons.flash_off;
    }
  }
}
