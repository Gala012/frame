import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../db_frame_elevate/data.dart';
import '../../db_frame_elevate/db_frame_elevate_entity.dart';
import '../../utils/image_processor.dart';
import '../../utils/index.dart';
import '../../utils/frame_meta_loader.dart';
import '../../utils/template_loader.dart';
import '../../models/template_data.dart';

class FrameElevateBatchEditorLogic extends GetxController {
  final previewKey = GlobalKey();
  final photoPaths = <String>[].obs;
  final currentPhotoIndex = 0.obs;
  final photoFiles = <File>[].obs;
  final photoFile = Rx<File?>(null);
  final isSaving = false.obs;
  final hasChanges = false.obs;
  final activeTab = 0.obs;
  final frameCategory = 0.obs;
  final selectedFrameIndex = (-1).obs;
  final frameWidthIndex = 1.obs;
  final currentFrameMeta = Rx<FrameMeta?>(null);
  final matTab = 0.obs;
  final matSize = 0.obs;
  final matColorIndex = 0.obs;
  final templateCategory = 0.obs;
  final selectedTemplateIndex = (-1).obs;
  final templates = <TemplateData>[].obs;
  List<TemplateData> get currentCategoryTemplates {
    if (templates.isEmpty) {
      return [];
    }
    const categoryKeys = [
      'traditional',
      'western',
      'photography',
      'modern',
      'warm',
      'exhibition'
    ];
    if (templateCategory.value < 0 ||
        templateCategory.value >= categoryKeys.length) {
      return [];
    }
    final key = categoryKeys[templateCategory.value];
    return TemplateLoader.getTemplatesByCategory(templates, key);
  }

  final bgColorIndex = 0.obs;
  final bgScenePath = Rx<String?>(null);
  final filterIndex = 0.obs;
  final filterIntensity = 0.8.obs;
  static const _frameCategoryFolders = [
    'fine_art',
    'oil',
    'modern',
    'photography',
    'calligraphy',
    'scroll',
    'chinese_painting',
  ];
  static const _frameCategoryCounts = [5, 4, 4, 4, 4, 3, 4];
  static const _frameIdPrefixes = [
    'frame_fa_',
    'frame_oil_',
    'frame_mod_',
    'frame_ph_',
    'frame_cal_',
    'frame_scroll_',
    'frame_cp_',
  ];
  List<String> get currentCategoryFrames {
    final catIndex = frameCategory.value;
    if (catIndex < 0 || catIndex >= _frameCategoryCounts.length) return [];
    final count = _frameCategoryCounts[catIndex];
    final prefix = _frameIdPrefixes[catIndex];
    final folder = _frameCategoryFolders[catIndex];
    return List.generate(
        count, (i) => 'assets/frames/$folder/${prefix}0${i + 1}');
  }

  String? get selectedFramePath {
    final frames = currentCategoryFrames;
    if (selectedFrameIndex.value < 0 ||
        selectedFrameIndex.value >= frames.length) {
      return null;
    }
    return frames[selectedFrameIndex.value];
  }

  static const _matSizeValues = [
    'none',
    'thin',
    'medium',
    'wide',
    'extra_wide'
  ];
  static const _frameWidthValues = ['medium', 'bold', 'extra'];
  static const _filterIds = [
    'original',
    'bw',
    'vintage',
    'cool',
    'warm',
    'fade',
    'vivid',
    'ink'
  ];
  static const _matColors = [
    Color(0xFFFFFFFF),
    Color(0xFFF5F5F0),
    Color(0xFFFAF0E6),
    Color(0xFFF0EAD6),
    Color(0xFFE8E4D4),
    Color(0xFFD4C5A9),
    Color(0xFFC8B89A),
    Color(0xFFE0E0E0),
    Color(0xFFB0B0B0),
    Color(0xFF808080),
    Color(0xFF404040),
    Color(0xFF1A1A1A),
    Color(0xFF2C3E50),
    Color(0xFF3D2B1F),
    Color(0xFF5C4033),
    Color(0xFF8B7355),
  ];
  static const _bgColors = [
    Color(0xFFFFFFFF),
    Color(0xFFFFFFF0),
    Color(0xFFFFF8E7),
    Color(0xFFF0F0F0),
    Color(0xFFC0C0C0),
    Color(0xFF36454F),
    Color(0xFF0A0A0A),
    Color(0xFF1B2A4A),
    Color(0xFFE8DCC8),
    Color(0xFFC9B99A),
    Color(0xFF6B4226),
    Color(0xFF4A6C8C),
    Color(0xFF2D4A2D),
    Color(0xFFF7F5F2),
    Color(0xFF878787),
    Color(0xFF1A1A1A),
  ];
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final paths = args?['photoPaths'] as List<dynamic>? ?? [];
    photoPaths.value = paths.cast<String>();
    photoFiles.value = photoPaths.map((path) => File(path)).toList();
    if (photoFiles.isNotEmpty) {
      photoFile.value = photoFiles[0];
    }
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final loadedTemplates = await TemplateLoader.loadTemplates();
      templates.value = loadedTemplates;
    } catch (e) {
      debugPrint('❌ Error loading templates: $e');
    }
  }

  String get pageTitle => 'Batch Frame';
  void onPhotoSwitch(int index) {
    if (index < 0 || index >= photoFiles.length) return;
    currentPhotoIndex.value = index;
    photoFile.value = photoFiles[index];
  }

  String get currentPhotoIndexText {
    return '${currentPhotoIndex.value + 1}/${photoFiles.length}';
  }

  void onTabTap(int index) => activeTab.value = index;
  void onFrameCategoryTap(int index) {
    frameCategory.value = index;
    selectedFrameIndex.value = -1;
    currentFrameMeta.value = null;
    hasChanges.value = true;
  }

  void onFrameSelect(int index) async {
    selectedFrameIndex.value = index;
    hasChanges.value = true;
    final framePath = selectedFramePath;
    if (framePath != null) {
      final meta = await FrameMetaLoader().getMetaOrDefault(framePath);
      currentFrameMeta.value = meta;
    }
  }

  void onRemoveFrame() {
    selectedFrameIndex.value = -1;
    currentFrameMeta.value = null;
    matSize.value = 0;
    hasChanges.value = true;
  }

  void onFrameWidthTap(int index) {
    frameWidthIndex.value = index;
    hasChanges.value = true;
  }

  void onMatTabTap(int index) => matTab.value = index;
  void onMatSizeTap(int index) {
    matSize.value = index;
    hasChanges.value = true;
  }

  void onMatColorTap(int index) {
    matColorIndex.value = index;
    hasChanges.value = true;
  }

  void onTemplateCategoryTap(int index) => templateCategory.value = index;
  void onTemplateSelect(int index) async {
    selectedTemplateIndex.value = index;
    hasChanges.value = true;
    final templateList = currentCategoryTemplates;
    if (index >= 0 && index < templateList.length) {
      final template = templateList[index];
      await _applyTemplate(template);
    }
  }

  Future<void> _applyTemplate(TemplateData template) async {
    if (template.frame != null) {
      await _applyTemplateFrame(template.frame!);
    } else {
      selectedFrameIndex.value = -1;
      currentFrameMeta.value = null;
    }
    _applyTemplateMat(template.mat);
    _applyTemplateBackground(template.background);
  }

  Future<void> _applyTemplateFrame(String frameId) async {
    final parts = frameId.split('_');
    if (parts.length < 3) {
      return;
    }
    final categoryPrefix = '${parts[0]}_${parts[1]}_';
    final frameNumber = parts[2];
    int categoryIndex = -1;
    for (int i = 0; i < _frameIdPrefixes.length; i++) {
      if (_frameIdPrefixes[i] == categoryPrefix) {
        categoryIndex = i;
        break;
      }
    }
    if (categoryIndex == -1) {
      return;
    }
    final frameIndex = int.tryParse(frameNumber);
    if (frameIndex == null || frameIndex < 1) {
      return;
    }
    frameCategory.value = categoryIndex;
    onFrameSelect(frameIndex - 1);
  }

  void _applyTemplateMat(MatConfig mat) {
    final sizeIndex = _matSizeValues.indexOf(mat.size);
    if (sizeIndex != -1) {
      matSize.value = sizeIndex;
    }
    final colorIndex = _matColors.indexOf(mat.colorValue);
    if (colorIndex != -1) {
      matColorIndex.value = colorIndex;
    } else {
      matColorIndex.value = _findClosestColorIndex(mat.colorValue, _matColors);
    }
  }

  void _applyTemplateBackground(BackgroundConfig background) {
    final currentTemplates = currentCategoryTemplates;
    if (selectedTemplateIndex.value >= 0 &&
        selectedTemplateIndex.value < currentTemplates.length) {
      final template = currentTemplates[selectedTemplateIndex.value];
      bgScenePath.value = template.previewPath;
    } else if (background.type == 'solid' && background.color != null) {
      bgScenePath.value = null;
      final colorValue = background.colorValue!;
      final colorIndex = _bgColors.indexOf(colorValue);
      if (colorIndex != -1) {
        bgColorIndex.value = colorIndex;
      } else {
        bgColorIndex.value = _findClosestColorIndex(colorValue, _bgColors);
      }
    }
  }

  int _findClosestColorIndex(Color target, List<Color> colors) {
    if (colors.isEmpty) return 0;
    int closestIndex = 0;
    double closestDistance = double.infinity;
    for (int i = 0; i < colors.length; i++) {
      final distance = _colorDistance(target, colors[i]);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  double _colorDistance(Color c1, Color c2) {
    final dr = c1.red - c2.red;
    final dg = c1.green - c2.green;
    final db = c1.blue - c2.blue;
    return (dr * dr + dg * dg + db * db).toDouble();
  }

  void onBgColorTap(int index) {
    bgColorIndex.value = index;
    bgScenePath.value = null;
    hasChanges.value = true;
  }

  void onFilterTap(int index) {
    filterIndex.value = index;
    hasChanges.value = true;
  }

  void onFilterIntensityChanged(double value) {
    filterIntensity.value = value;
    hasChanges.value = true;
  }

  Future<File?> capturePreviewAsImage() async {
    try {
      final boundary = previewKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint('❌ Failed to find RenderRepaintBoundary');
        return null;
      }
      final originalImageDimensions = await _getOriginalImageDimensions();
      double capturePixelRatio;
      if (originalImageDimensions != null) {
        final originalWidth = originalImageDimensions['width']!.toDouble();
        final originalHeight = originalImageDimensions['height']!.toDouble();
        final renderBox = boundary as RenderBox;
        final previewWidth = renderBox.size.width;
        final previewHeight = renderBox.size.height;
        final widthRatio = originalWidth / previewWidth;
        final heightRatio = originalHeight / previewHeight;
        capturePixelRatio =
            (widthRatio < heightRatio ? widthRatio : heightRatio)
                .clamp(3.0, 10.0);
      } else {
        final devicePixelRatio = Get.context != null
            ? MediaQuery.of(Get.context!).devicePixelRatio
            : 3.0;
        capturePixelRatio = (devicePixelRatio * 2).clamp(3.0, 8.0);
      }
      final image = await boundary.toImage(pixelRatio: capturePixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        debugPrint('❌ Failed to convert image to bytes');
        return null;
      }
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/preview_$timestamp.png');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      return tempFile;
    } catch (e) {
      debugPrint('❌ Failed to capture preview: $e');
      return null;
    }
  }

  Future<Map<String, int>?> _getOriginalImageDimensions() async {
    try {
      if (photoFile.value == null || !photoFile.value!.existsSync()) {
        return null;
      }
      final bytes = await photoFile.value!.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      debugPrint('⚠️ Failed to get original image dimensions: $e');
      return null;
    }
  }

  Future<Map<String, int>?> getImageDimensions(File imageFile) async {
    try {
      if (!imageFile.existsSync()) {
        return null;
      }
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      debugPrint('⚠️ Failed to get image dimensions: $e');
      return null;
    }
  }

  Future<void> onSaveTap() async {
    if (isSaving.value) return;
    await _saveBatchMode();
  }

  Future<void> _saveBatchMode() async {
    if (photoFiles.isEmpty) {
      errorToast('No images to save');
      return;
    }
    try {
      isSaving.value = true;
      int successCount = 0;
      int failCount = 0;
      final db = FrameElevateDB.to;
      final framePath = selectedFramePath;
      final frameId = framePath != null ? framePath.split('/').last : null;
      for (int i = 0; i < photoFiles.length; i++) {
        try {
          currentPhotoIndex.value = i;
          photoFile.value = photoFiles[i];
          await Future.delayed(const Duration(milliseconds: 100));
          final capturedFile = await capturePreviewAsImage();
          if (capturedFile == null) {
            failCount++;
            continue;
          }
          final dimensions = await getImageDimensions(capturedFile);
          final outputWidth = dimensions?['width'];
          final outputHeight = dimensions?['height'];
          final savedFile =
              await ImageProcessor.saveToAppDocuments(capturedFile);
          if (savedFile == null) {
            failCount++;
            continue;
          }
          final thumbFile = await ImageProcessor.generateThumbnail(savedFile);
          final thumbPath = thumbFile?.path ?? savedFile.path;
          try {
            await Gal.putImage(savedFile.path);
          } catch (_) {
            failCount++;
            continue;
          }
          final artworkId = await db.insertArtwork(ArtworkEntity(
            thumbnailPath: thumbPath,
            outputPath: savedFile.path,
            featureType: 'batch',
            createdAt: DateTime.now().toIso8601String(),
            outputWidth: outputWidth,
            outputHeight: outputHeight,
          ));
          await db.insertArtworkSource(ArtworkSourceEntity(
            artworkId: artworkId,
            sourcePath: photoPaths[i],
            sortOrder: i,
          ));
          String? templateId;
          if (selectedTemplateIndex.value >= 0) {
            final templateList = currentCategoryTemplates;
            if (selectedTemplateIndex.value < templateList.length) {
              templateId = templateList[selectedTemplateIndex.value].id;
            }
          }
          await db.insertArtworkParams(ArtworkParamsEntity(
            artworkId: artworkId,
            frameId: frameId,
            frameWidth: _frameWidthValues[frameWidthIndex.value],
            matSize: _matSizeValues[matSize.value],
            matColor: _colorToHex(_matColors[matColorIndex.value]),
            matTexture: null,
            bgType: bgScenePath.value != null ? 'scene' : 'solid',
            bgValue:
                bgScenePath.value ?? _colorToHex(_bgColors[bgColorIndex.value]),
            filterId: _filterIds[filterIndex.value],
            filterIntensity: filterIntensity.value,
            sceneId: null,
            sceneSize: null,
            sigStyle: 'none',
            sigArtist: null,
            sigTitle: null,
            sigYear: null,
            sigMedium: null,
            sigSize: null,
            sigX: 0.75,
            sigY: 0.85,
            templateId: templateId,
          ));
          successCount++;
        } catch (e) {
          debugPrint('Failed to save photo $i: $e');
          failCount++;
        }
      }
      hasChanges.value = false;
      if (failCount > 0) {
        errorToast('$successCount photos saved, $failCount failed');
      } else {
        successToast('$successCount photos saved to gallery!');
      }
      Get.until((route) => route.settings.name == '/frame_tab');
    } catch (e) {
      errorToast('Batch save failed: ${e.toString()}');
    } finally {
      isSaving.value = false;
    }
  }

  void onBackTap() {
    if (!hasChanges.value) {
      Get.back();
      return;
    }
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Discard changes?',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text(
          'Your edits will be lost if you go back.',
          style: TextStyle(color: Color(0xFF888888), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Discard',
                style: TextStyle(color: Color(0xFFFF4444))),
          ),
        ],
      ),
    );
  }

  String _colorToHex(Color color) {
    final r = color.r.round().toRadixString(16).padLeft(2, '0');
    final g = color.g.round().toRadixString(16).padLeft(2, '0');
    final b = color.b.round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  Color get currentMatColor => _matColors[matColorIndex.value];
  Color get currentBgColor => _bgColors[bgColorIndex.value];
}
