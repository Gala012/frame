import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../utils/index.dart';
import '../../utils/image_processor.dart';
class PhotoAssetModel {
  final AssetEntity asset;
  Uint8List? thumbnail;
  PhotoAssetModel({required this.asset, this.thumbnail});
}
class FrameElevateComboPickLogic extends GetxController {
  final selectedLayout = 2.obs;
  final selectedIndices = <int>[].obs;
  final photos = <PhotoAssetModel>[].obs;
  final isLoading = false.obs;
  final isLoadingImage = false.obs;
  final Map<int, Future<Uint8List?>> _loadingThumbnails = {};
  static const _layoutCounts = [2, 3, 4, 3, 4, 9];
  static const _layoutLabels = [
    '2 Grid',
    '3 Col',
    '4 Grid',
    'L-Type',
    'T-Type',
    '9 Grid'
  ];
  int get maxCount => _layoutCounts[selectedLayout.value];
  String get layoutLabel => _layoutLabels[selectedLayout.value];
  @override
  void onInit() {
    super.onInit();
    _requestPermissionAndLoad();
  }
  Future<void> _requestPermissionAndLoad() async {
    try {
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (ps.isAuth || ps.hasAccess) {
        await _loadPhotos();
      } else {
        errorToast('Photos permission is required. Please enable it in Settings.');
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      }
    } catch (e) {
      errorToast('Failed to request permission');
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    }
  }
  Future<void> _loadPhotos() async {
    try {
      isLoading.value = true;
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );
      if (paths.isEmpty) {
        errorToast('No photos found in your gallery');
        return;
      }
      await _loadPhotosFromPath(paths[0]);
    } catch (e) {
      errorToast('Failed to load photos');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _loadPhotosFromPath(AssetPathEntity path) async {
    try {
      isLoading.value = true;
      final int count = await path.assetCountAsync;
      final List<AssetEntity> assets = await path.getAssetListRange(
        start: 0,
        end: count > 1000 ? 1000 : count,
      );
      photos.clear();
      _loadingThumbnails.clear();
      for (final asset in assets) {
        photos.add(PhotoAssetModel(asset: asset, thumbnail: null));
      }
    } catch (e) {
      errorToast('Failed to load photos');
    } finally {
      isLoading.value = false;
    }
  }
  Future<Uint8List?> loadThumbnail(int index) async {
    if (index < 0 || index >= photos.length) return null;
    final model = photos[index];
    if (model.thumbnail != null) return model.thumbnail;
    if (_loadingThumbnails.containsKey(index)) {
      return _loadingThumbnails[index];
    }
    final loadingFuture = model.asset.thumbnailDataWithSize(
      const ThumbnailSize(200, 200),
    );
    _loadingThumbnails[index] = loadingFuture;
    try {
      final thumbnail = await loadingFuture;
      model.thumbnail = thumbnail;
      _loadingThumbnails.remove(index);
      return thumbnail;
    } catch (e) {
      _loadingThumbnails.remove(index);
      return null;
    }
  }
  void onLayoutTap(int index) {
    if (selectedLayout.value == index) return;
    selectedLayout.value = index;
    selectedIndices.clear();
    successToast('Layout changed to ${_layoutLabels[index]}');
  }
  void onPhotoTap(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else if (selectedIndices.length < maxCount) {
      selectedIndices.add(index);
    } else {
      errorToast('This layout needs exactly $maxCount photos');
    }
  }
  void onDoneTap() async {
    if (selectedIndices.length != maxCount) {
      final remaining = maxCount - selectedIndices.length;
      errorToast('Please select $remaining more photo${remaining > 1 ? 's' : ''}');
      return;
    }
    try {
      isLoadingImage.value = true;
      await Future.delayed(const Duration(milliseconds: 200));
      final List<File> selectedFiles = [];
      for (final selectedIdx in selectedIndices) {
        final model = photos[selectedIdx];
        final file = await model.asset.file;
        if (file == null) {
          errorToast('Failed to load image, please try again');
          return;
        }
        selectedFiles.add(file);
      }
      final combinedFile = await ImageProcessor.combineImages(
        imageFiles: selectedFiles,
        layoutType: selectedLayout.value,
        targetSize: 2048,
        quality: 90,
        gap: 4,
      );
      if (combinedFile == null) {
        errorToast('Failed to combine images, please try again');
        return;
      }
      Get.toNamed(
        '/combo-frame/editor',
        arguments: {
          'photoPath': combinedFile.path,
          'featureType': 'combo',
          'layoutType': selectedLayout.value,
          'layoutLabel': layoutLabel,
          'photoCount': selectedIndices.length,
        },
      );
    } catch (e) {
      errorToast('Failed to process images, please try again');
    } finally {
      isLoadingImage.value = false;
    }
  }
  void onClearTap() {
    if (selectedIndices.isEmpty) return;
    selectedIndices.clear();
    successToast('Selection cleared');
  }
  Future<void> refreshPhotos() async {
    selectedIndices.clear();
    await _loadPhotos();
  }
}
