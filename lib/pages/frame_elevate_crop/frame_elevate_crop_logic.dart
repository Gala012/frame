import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/index.dart';
import '../../utils/image_processor.dart';
class FrameElevateCropLogic extends GetxController {
  final selectedRatio = 0.obs;
  late final String photoPath;
  final currentPhotoFile = Rx<File?>(null);
  final isLoading = false.obs;
  final isProcessing = false.obs;
  final imageWidth = 0.obs;
  final imageHeight = 0.obs;
  final imageDisplayLeft = 0.0.obs;
  final imageDisplayTop = 0.0.obs;
  final imageDisplayWidth = 0.0.obs;
  final imageDisplayHeight = 0.0.obs;
  final containerWidth = 0.0.obs;
  final containerHeight = 0.0.obs;
  final cropBoxLeft = 0.0.obs;
  final cropBoxTop = 0.0.obs;
  final cropBoxWidth = 0.0.obs;
  final cropBoxHeight = 0.0.obs;
  Offset? _lastFocalPoint;
  String? _draggingCorner;
  Offset? _dragStartPoint;
  double? _dragStartWidth;
  double? _dragStartHeight;
  double? _dragStartLeft;
  double? _dragStartTop;
  late String _originalPath;
  static const List<double?> _ratioValues = [
    null, 1.0, 4 / 3, 3 / 4, 16 / 9, 9 / 16
  ];
  @override
  void onInit() {
    super.onInit();
    debugPrint('🔄 Crop page onInit');
    final args = Get.arguments as Map<String, dynamic>?;
    debugPrint('📦 Arguments: $args');
    photoPath = args?['photoPath'] as String? ?? '';
    debugPrint('📸 Photo path: $photoPath');
    _originalPath = photoPath;
    if (photoPath.isEmpty) {
      debugPrint('❌ Photo path is empty!');
      errorToast('No photo selected');
      Get.back();
      return;
    }
    _loadPhoto(photoPath);
  }
  Future<void> _loadPhoto(String path) async {
    try {
      debugPrint('🔄 Loading photo from: $path');
      isLoading.value = true;
      final file = File(path);
      if (!await file.exists()) {
        debugPrint('❌ File does not exist at path: $path');
        errorToast('Photo file not found');
        Get.back();
        return;
      }
      debugPrint('✅ File exists, size: ${await file.length()} bytes');
      currentPhotoFile.value = file;
      await _updateImageSize(file);
      debugPrint('✅ Photo loaded successfully');
    } catch (e) {
      debugPrint('❌ Error loading photo: $e');
      errorToast('Failed to load image, please try again');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _updateImageSize(File file) async {
    final info = await ImageProcessor.getImageInfo(file);
    if (info != null) {
      imageWidth.value = info['width'];
      imageHeight.value = info['height'];
    }
  }
  void updateContainerSize(double width, double height) {
    if (containerWidth.value != width || containerHeight.value != height) {
      containerWidth.value = width;
      containerHeight.value = height;
    }
  }
  void updateImageDisplayRect(Rect displayRect) {
    if (imageWidth.value == 0 || imageHeight.value == 0) return;
    final containerW = displayRect.width;
    final containerH = displayRect.height;
    final imageAspect = imageWidth.value / imageHeight.value;
    final containerAspect = containerW / containerH;
    double actualW, actualH, offsetX, offsetY;
    if (imageAspect > containerAspect) {
      actualW = containerW;
      actualH = containerW / imageAspect;
      offsetX = 0;
      offsetY = (containerH - actualH) / 2;
    } else {
      actualH = containerH;
      actualW = containerH * imageAspect;
      offsetX = (containerW - actualW) / 2;
      offsetY = 0;
    }
    imageDisplayLeft.value = offsetX;
    imageDisplayTop.value = offsetY;
    imageDisplayWidth.value = actualW;
    imageDisplayHeight.value = actualH;
    if (cropBoxWidth.value == 0 && imageDisplayWidth.value > 0) {
      _initializeCropBox();
    }
  }
  void _initializeCropBox() {
    if (imageDisplayWidth.value == 0 || imageDisplayHeight.value == 0) return;
    final ratio = _ratioValues[selectedRatio.value];
    double boxW, boxH;
    final maxW = imageDisplayWidth.value * 0.95;
    final maxH = imageDisplayHeight.value * 0.95;
    if (ratio == null) {
      final size = maxW < maxH ? maxW : maxH;
      boxW = size;
      boxH = size;
    } else {
      if (ratio >= 1.0) {
        boxW = maxW;
        boxH = boxW / ratio;
        if (boxH > maxH) {
          boxH = maxH;
          boxW = boxH * ratio;
        }
      } else {
        boxH = maxH;
        boxW = boxH * ratio;
        if (boxW > maxW) {
          boxW = maxW;
          boxH = boxW / ratio;
        }
      }
    }
    cropBoxWidth.value = boxW;
    cropBoxHeight.value = boxH;
    cropBoxLeft.value = imageDisplayLeft.value + (imageDisplayWidth.value - boxW) / 2;
    cropBoxTop.value = imageDisplayTop.value + (imageDisplayHeight.value - boxH) / 2;
    _constrainCropBox();
  }
  void onRatioTap(int index) {
    selectedRatio.value = index;
    _initializeCropBox();
  }
  void onCropBoxPanStart(DragStartDetails details) {
    _lastFocalPoint = details.globalPosition;
  }
  void onCropBoxPanUpdate(DragUpdateDetails details) {
    if (_lastFocalPoint == null) return;
    final delta = details.globalPosition - _lastFocalPoint!;
    cropBoxLeft.value += delta.dx;
    cropBoxTop.value += delta.dy;
    _constrainCropBox();
    _lastFocalPoint = details.globalPosition;
  }
  void onCornerDragStart(String corner, DragStartDetails details) {
    _draggingCorner = corner;
    _dragStartPoint = details.globalPosition;
    _dragStartWidth = cropBoxWidth.value;
    _dragStartHeight = cropBoxHeight.value;
    _dragStartLeft = cropBoxLeft.value;
    _dragStartTop = cropBoxTop.value;
  }
  void onCornerDragUpdate(DragUpdateDetails details) {
    if (_draggingCorner == null || _dragStartPoint == null) return;
    final delta = details.globalPosition - _dragStartPoint!;
    final ratio = _ratioValues[selectedRatio.value];
    double newW = _dragStartWidth!;
    double newH = _dragStartHeight!;
    double newLeft = _dragStartLeft!;
    double newTop = _dragStartTop!;
    switch (_draggingCorner) {
      case 'tl':
        newW = _dragStartWidth! - delta.dx;
        newH = ratio != null ? newW / ratio : _dragStartHeight! - delta.dy;
        newLeft = _dragStartLeft! + (_dragStartWidth! - newW);
        newTop = _dragStartTop! + (_dragStartHeight! - newH);
        break;
      case 'tr':
        newW = _dragStartWidth! + delta.dx;
        newH = ratio != null ? newW / ratio : _dragStartHeight! - delta.dy;
        newTop = _dragStartTop! + (_dragStartHeight! - newH);
        break;
      case 'bl':
        newW = _dragStartWidth! - delta.dx;
        newH = ratio != null ? newW / ratio : _dragStartHeight! + delta.dy;
        newLeft = _dragStartLeft! + (_dragStartWidth! - newW);
        break;
      case 'br':
        newW = _dragStartWidth! + delta.dx;
        newH = ratio != null ? newW / ratio : _dragStartHeight! + delta.dy;
        break;
    }
    if (newW < 50 || newH < 50) return;
    final minLeft = imageDisplayLeft.value;
    final minTop = imageDisplayTop.value;
    final maxRight = imageDisplayLeft.value + imageDisplayWidth.value;
    final maxBottom = imageDisplayTop.value + imageDisplayHeight.value;
    if (newLeft < minLeft || newTop < minTop ||
        newLeft + newW > maxRight || newTop + newH > maxBottom) {
      return;
    }
    cropBoxWidth.value = newW;
    cropBoxHeight.value = newH;
    cropBoxLeft.value = newLeft;
    cropBoxTop.value = newTop;
  }
  void onCornerDragEnd(DragEndDetails details) {
    _draggingCorner = null;
    _dragStartPoint = null;
  }
  void _constrainCropBox() {
    if (imageDisplayWidth.value == 0 || imageDisplayHeight.value == 0) return;
    final minLeft = imageDisplayLeft.value;
    final minTop = imageDisplayTop.value;
    final maxLeft = imageDisplayLeft.value + imageDisplayWidth.value - cropBoxWidth.value;
    final maxTop = imageDisplayTop.value + imageDisplayHeight.value - cropBoxHeight.value;
    cropBoxLeft.value = cropBoxLeft.value.clamp(minLeft, maxLeft < minLeft ? minLeft : maxLeft);
    cropBoxTop.value = cropBoxTop.value.clamp(minTop, maxTop < minTop ? minTop : maxTop);
  }
  Rect _screenToCropCoords() {
    final scale = imageWidth.value / imageDisplayWidth.value;
    final relLeft = cropBoxLeft.value - imageDisplayLeft.value;
    final relTop = cropBoxTop.value - imageDisplayTop.value;
    final pixX = (relLeft * scale).clamp(0.0, imageWidth.value.toDouble());
    final pixY = (relTop * scale).clamp(0.0, imageHeight.value.toDouble());
    final pixW = (cropBoxWidth.value * scale).clamp(1.0, imageWidth.value.toDouble() - pixX);
    final pixH = (cropBoxHeight.value * scale).clamp(1.0, imageHeight.value.toDouble() - pixY);
    return Rect.fromLTWH(pixX, pixY, pixW, pixH);
  }
  Future<void> onRotateTap() async {
    if (currentPhotoFile.value == null || isProcessing.value) return;
    try {
      isProcessing.value = true;
      await Future.delayed(const Duration(milliseconds: 100));
      final rotated = await ImageProcessor.rotateImage(
        imageFile: currentPhotoFile.value!,
        angle: 90,
      );
      if (rotated != null) {
        cropBoxWidth.value = 0;
        cropBoxHeight.value = 0;
        currentPhotoFile.value = rotated;
        await _updateImageSize(rotated);
        final temp = imageWidth.value;
        imageWidth.value = imageHeight.value;
        imageHeight.value = temp;
      } else {
        errorToast('Failed to rotate');
      }
    } catch (e) {
      errorToast('Rotate failed');
    } finally {
      isProcessing.value = false;
    }
  }
  Future<void> onResetTap() async {
    if (isProcessing.value) return;
    try {
      isProcessing.value = true;
      await _loadPhoto(_originalPath);
      selectedRatio.value = 0;
      cropBoxWidth.value = 0;
      cropBoxHeight.value = 0;
    } catch (e) {
      errorToast('Reset failed');
    } finally {
      isProcessing.value = false;
    }
  }
  Future<void> onConfirmTap() async {
    if (currentPhotoFile.value == null || isProcessing.value) return;
    try {
      isProcessing.value = true;
      await Future.delayed(const Duration(milliseconds: 100));
      final cropRect = _screenToCropCoords();
      final x = cropRect.left.round();
      final y = cropRect.top.round();
      final w = cropRect.width.round();
      final h = cropRect.height.round();
      if (w < 10 || h < 10) {
        errorToast('Crop area is too small');
        return;
      }
      final cropped = await ImageProcessor.cropImage(
        imageFile: currentPhotoFile.value!,
        x: x,
        y: y,
        width: w,
        height: h,
        quality: 95,
      );
      if (cropped == null) {
        errorToast('Failed to crop image');
        return;
      }
      final route = Get.currentRoute;
      final targetRoute = route.contains('photo')
          ? '/photo-frame/editor'
          : '/single-frame/editor';
      Get.offNamed(
        targetRoute,
        arguments: {
          'photoPath': cropped.path,
          'featureType': route.contains('photo') ? 'photo' : 'single',
          'cropBoxWidth': cropBoxWidth.value,
          'cropBoxHeight': cropBoxHeight.value,
        },
      );
    } catch (e) {
      errorToast('Failed to process image');
    } finally {
      isProcessing.value = false;
    }
  }
}
