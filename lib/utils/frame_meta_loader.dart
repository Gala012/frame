import 'frame_meta_config.dart';
export 'frame_meta_config.dart' show FrameMeta, EdgeDimensions;
class FrameMetaLoader {
  static final FrameMetaLoader _instance = FrameMetaLoader._();
  factory FrameMetaLoader() => _instance;
  FrameMetaLoader._();
  final Map<String, FrameMeta> _cache = {};
  Future<FrameMeta?> loadMeta(String framePath) async {
    final parts = framePath.split('/');
    if (parts.isEmpty) return null;
    final frameId = parts.last;
    if (_cache.containsKey(frameId)) {
      return _cache[frameId];
    }
    final meta = FrameMetaConfig.getMeta(frameId);
    if (meta != null) {
      _cache[frameId] = meta;
    }
    return meta;
  }
  Future<FrameMeta> getMetaOrDefault(String framePath) async {
    final meta = await loadMeta(framePath);
    if (meta != null) return meta;
    final frameId = framePath.split('/').last;
    return FrameMeta(
      id: frameId,
      category: 'unknown',
      borderWidth: 30,
    );
  }
  void clearCache() {
    _cache.clear();
  }
  Future<void> preloadCategory(String category, List<String> framePaths) async {
    for (final path in framePaths) {
      await loadMeta(path);
    }
  }
}
