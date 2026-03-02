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
class FrameElevateSinglePickLogic extends GetxController {
  final photos = <PhotoAssetModel>[].obs;
  final selectedIndex = (-1).obs;
  final isLoading = false.obs;
  final isLoadingImage = false.obs;
  final Map<int, Future<Uint8List?>> _loadingThumbnails = {};
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
  void onPhotoTap(int index) async {
    if (isLoadingImage.value) return;
    selectedIndex.value = index;
    final model = photos[index];
    try {
      isLoadingImage.value = true;
      await Future.delayed(const Duration(milliseconds: 200));
      final file = await model.asset.file;
      if (file == null) {
        errorToast('Failed to load image, please try again');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 50));
      final compressedFile = await ImageProcessor.compressImage(
        imageFile: file,
        maxWidth: 2048,
        maxHeight: 2048,
        quality: 85,
      );
      if (compressedFile == null) {
        errorToast('Failed to process image, please try again');
        return;
      }
      Get.toNamed(
        '/single-frame/crop',
        arguments: {'photoPath': compressedFile.path},
      );
    } catch (e) {
      errorToast('Failed to load image, please try again');
    } finally {
      isLoadingImage.value = false;
    }
  }
  Future<void> refreshPhotos() async {
    selectedIndex.value = -1;
    await _loadPhotos();
  }
}
