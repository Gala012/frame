import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
class ImageProcessor {
  static Future<Map<String, dynamic>?> getImageInfo(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;
      final fileSize = await imageFile.length();
      return {
        'width': image.width,
        'height': image.height,
        'sizeKB': fileSize / 1024,
      };
    } catch (e) {
      return null;
    }
  }
  static Future<File?> rotateImage({
    required File imageFile,
    required int angle,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      var image = img.decodeImage(bytes);
      if (image == null) return null;
      image = img.copyRotate(image, angle: angle);
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFile = File('${tempDir.path}/rotated_$timestamp.jpg');
      await outputFile.writeAsBytes(img.encodeJpg(image, quality: 95));
      return outputFile;
    } catch (e) {
      return null;
    }
  }
  static Future<File?> cropImage({
    required File imageFile,
    required int x,
    required int y,
    required int width,
    required int height,
    int quality = 90,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;
      final cropX = x.clamp(0, image.width);
      final cropY = y.clamp(0, image.height);
      final cropW = width.clamp(1, image.width - cropX);
      final cropH = height.clamp(1, image.height - cropY);
      final cropped = img.copyCrop(image, x: cropX, y: cropY, width: cropW, height: cropH);
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFile = File('${tempDir.path}/cropped_$timestamp.jpg');
      await outputFile.writeAsBytes(img.encodeJpg(cropped, quality: quality));
      return outputFile;
    } catch (e) {
      return null;
    }
  }
  static Future<File?> saveToAppDocuments(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final worksDir = Directory('${appDir.path}/works');
      if (!await worksDir.exists()) {
        await worksDir.create(recursive: true);
      }
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = imageFile.path.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
      final outputPath = '${worksDir.path}/work_$timestamp.$extension';
      return await imageFile.copy(outputPath);
    } catch (e) {
      return null;
    }
  }
  static Future<File?> generateThumbnail(File imageFile, {int size = 300}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;
      final thumb = img.copyResize(image, width: size, height: size);
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final thumbFile = File('${tempDir.path}/thumb_$timestamp.jpg');
      await thumbFile.writeAsBytes(img.encodeJpg(thumb, quality: 80));
      return thumbFile;
    } catch (e) {
      return null;
    }
  }
  static Future<File?> compressImage({
    required File imageFile,
    int maxWidth = 2048,
    int maxHeight = 2048,
    int quality = 85,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      var image = img.decodeImage(bytes);
      if (image == null) return null;
      if (image.width > maxWidth || image.height > maxHeight) {
        final aspectRatio = image.width / image.height;
        int newWidth, newHeight;
        if (aspectRatio > 1) {
          newWidth = maxWidth;
          newHeight = (maxWidth / aspectRatio).round();
        } else {
          newHeight = maxHeight;
          newWidth = (maxHeight * aspectRatio).round();
        }
        image = img.copyResize(image, width: newWidth, height: newHeight);
      }
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFile = File('${tempDir.path}/compressed_$timestamp.jpg');
      await outputFile.writeAsBytes(img.encodeJpg(image, quality: quality));
      return outputFile;
    } catch (e) {
      return null;
    }
  }
  static Future<File?> combineImages({
    required List<File> imageFiles,
    required int layoutType,
    int targetSize = 2048,
    int quality = 90,
    int gap = 4,
  }) async {
    try {
      final images = <img.Image>[];
      for (final file in imageFiles) {
        final bytes = await file.readAsBytes();
        final image = img.decodeImage(bytes);
        if (image == null) return null;
        images.add(image);
      }
      if (images.isEmpty) return null;
      img.Image? combined;
      switch (layoutType) {
        case 0:
          combined = _combine2Grid(images, targetSize, gap);
          break;
        case 1:
          combined = _combine3Columns(images, targetSize, gap);
          break;
        case 2:
          combined = _combine4Grid(images, targetSize, gap);
          break;
        case 3:
          combined = _combineLType(images, targetSize, gap);
          break;
        case 4:
          combined = _combineTType(images, targetSize, gap);
          break;
        case 5:
          combined = _combine9Grid(images, targetSize, gap);
          break;
        default:
          return null;
      }
      if (combined == null) return null;
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFile = File('${tempDir.path}/combo_$timestamp.jpg');
      await outputFile.writeAsBytes(img.encodeJpg(combined, quality: quality));
      return outputFile;
    } catch (e) {
      return null;
    }
  }
  static img.Image? _combine2Grid(List<img.Image> images, int targetSize, int gap) {
    if (images.length < 2) return null;
    final cellSize = (targetSize - gap) ~/ 2;
    final canvas = img.Image(width: targetSize, height: cellSize);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    final img1 = img.copyResize(images[0], width: cellSize, height: cellSize);
    img.compositeImage(canvas, img1, dstX: 0, dstY: 0);
    final img2 = img.copyResize(images[1], width: cellSize, height: cellSize);
    img.compositeImage(canvas, img2, dstX: cellSize + gap, dstY: 0);
    return canvas;
  }
  static img.Image? _combine3Columns(List<img.Image> images, int targetSize, int gap) {
    if (images.length < 3) return null;
    final cellSize = (targetSize - gap * 2) ~/ 3;
    final canvas = img.Image(width: targetSize, height: cellSize);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    for (int i = 0; i < 3; i++) {
      final resized = img.copyResize(images[i], width: cellSize, height: cellSize);
      img.compositeImage(canvas, resized, dstX: i * (cellSize + gap), dstY: 0);
    }
    return canvas;
  }
  static img.Image? _combine4Grid(List<img.Image> images, int targetSize, int gap) {
    if (images.length < 4) return null;
    final cellSize = (targetSize - gap) ~/ 2;
    final canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    final img1 = img.copyResize(images[0], width: cellSize, height: cellSize);
    img.compositeImage(canvas, img1, dstX: 0, dstY: 0);
    final img2 = img.copyResize(images[1], width: cellSize, height: cellSize);
    img.compositeImage(canvas, img2, dstX: cellSize + gap, dstY: 0);
    final img3 = img.copyResize(images[2], width: cellSize, height: cellSize);
    img.compositeImage(canvas, img3, dstX: 0, dstY: cellSize + gap);
    final img4 = img.copyResize(images[3], width: cellSize, height: cellSize);
    img.compositeImage(canvas, img4, dstX: cellSize + gap, dstY: cellSize + gap);
    return canvas;
  }
  static img.Image? _combineLType(List<img.Image> images, int targetSize, int gap) {
    if (images.length < 3) return null;
    final leftWidth = (targetSize * 2 ~/ 3) - gap ~/ 2;
    final rightWidth = targetSize - leftWidth - gap;
    final rightHeight = (targetSize - gap) ~/ 2;
    final canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    final img1 = img.copyResize(images[0], width: leftWidth, height: targetSize);
    img.compositeImage(canvas, img1, dstX: 0, dstY: 0);
    final img2 = img.copyResize(images[1], width: rightWidth, height: rightHeight);
    img.compositeImage(canvas, img2, dstX: leftWidth + gap, dstY: 0);
    final img3 = img.copyResize(images[2], width: rightWidth, height: rightHeight);
    img.compositeImage(canvas, img3, dstX: leftWidth + gap, dstY: rightHeight + gap);
    return canvas;
  }
  static img.Image? _combineTType(List<img.Image> images, int targetSize, int gap) {
    if (images.length < 4) return null;
    final topHeight = (targetSize * 2 ~/ 3) - gap ~/ 2;
    final bottomHeight = targetSize - topHeight - gap;
    final bottomWidth = (targetSize - gap * 2) ~/ 3;
    final canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    final img1 = img.copyResize(images[0], width: targetSize, height: topHeight);
    img.compositeImage(canvas, img1, dstX: 0, dstY: 0);
    for (int i = 0; i < 3; i++) {
      final resized = img.copyResize(images[i + 1], width: bottomWidth, height: bottomHeight);
      img.compositeImage(canvas, resized,
        dstX: i * (bottomWidth + gap),
        dstY: topHeight + gap);
    }
    return canvas;
  }
  static img.Image? _combine9Grid(List<img.Image> images, int targetSize, int gap) {
    if (images.length < 9) return null;
    final cellSize = (targetSize - gap * 2) ~/ 3;
    final canvas = img.Image(width: targetSize, height: targetSize);
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final index = row * 3 + col;
        final resized = img.copyResize(images[index], width: cellSize, height: cellSize);
        img.compositeImage(canvas, resized,
          dstX: col * (cellSize + gap),
          dstY: row * (cellSize + gap));
      }
    }
    return canvas;
  }
}
