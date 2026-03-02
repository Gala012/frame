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
class FrameElevateBatchPickLogic extends GetxController {
  final photos = <PhotoAssetModel>[].obs;
  final selectedIndices = <int>[].obs;
  final albums = <AssetPathEntity>[].obs;
  final currentAlbumIndex = 0.obs;
  final isLoading = false.obs;
  final isProcessing = false.obs;
  static const maxSelect = 20;
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
        await _loadAlbums();
      } else {
        errorToast(
            'Photos permission is required. Please enable it in Settings.');
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      }
    } catch (e) {
      errorToast('Failed to request permission');
      await Future.delayed(const Duration(seconds: 2));
      Get.back();
    }
  }
  Future<void> _loadAlbums() async {
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
      albums.value = paths;
      await _loadPhotosFromAlbum(0);
    } catch (e) {
      errorToast('Failed to load albums');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _loadPhotosFromAlbum(int albumIndex) async {
    if (albumIndex < 0 || albumIndex >= albums.length) return;
    try {
      isLoading.value = true;
      currentAlbumIndex.value = albumIndex;
      selectedIndices.clear();
      final path = albums[albumIndex];
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
  void onAlbumSelect(int index) {
    if (index != currentAlbumIndex.value) {
      _loadPhotosFromAlbum(index);
    }
  }
  bool isSelected(int index) => selectedIndices.contains(index);
  void onPhotoTap(int index) {
    if (isSelected(index)) {
      selectedIndices.remove(index);
    } else if (selectedIndices.length < maxSelect) {
      selectedIndices.add(index);
    } else {
      errorToast('Maximum $maxSelect photos allowed');
    }
  }
  Future<void> onDoneTap() async {
    if (selectedIndices.length < 2) {
      errorToast('Please select at least 2 photos for batch framing');
      return;
    }
    if (isProcessing.value) return;
    try {
      isProcessing.value = true;
      successToast('Processing ${selectedIndices.length} photos...');
      final selectedPhotos = <PhotoAssetModel>[];
      for (final index in selectedIndices) {
        if (index < photos.length) {
          selectedPhotos.add(photos[index]);
        }
      }
      final compressedPaths = <String>[];
      for (int i = 0; i < selectedPhotos.length; i++) {
        final model = selectedPhotos[i];
        final file = await model.asset.file;
        if (file == null) {
          errorToast('Failed to load photo ${i + 1}, please try again');
          return;
        }
        final compressedFile = await ImageProcessor.compressImage(
          imageFile: file,
          maxWidth: 2048,
          maxHeight: 2048,
          quality: 85,
        );
        if (compressedFile == null) {
          errorToast('Failed to process photo ${i + 1}, please try again');
          return;
        }
        compressedPaths.add(compressedFile.path);
      }
      Get.toNamed(
        '/batch-frame/editor',
        arguments: {
          'photoPaths': compressedPaths,
        },
      );
    } catch (e) {
      errorToast('Failed to process images, please try again');
    } finally {
      isProcessing.value = false;
    }
  }
  void onClearTap() {
    selectedIndices.clear();
  }
  String get currentAlbumName {
    if (currentAlbumIndex.value < albums.length) {
      return albums[currentAlbumIndex.value].name;
    }
    return 'All';
  }
  Future<void> refreshPhotos() async {
    await _loadPhotosFromAlbum(currentAlbumIndex.value);
  }
}
