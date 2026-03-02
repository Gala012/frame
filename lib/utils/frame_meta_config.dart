import 'package:flutter/widgets.dart';
class FrameMetaConfig {
  static FrameMeta? getMeta(String frameId) {
    return _allFrames[frameId];
  }
  static List<String> getFrameIdsByCategory(String category) {
    return _allFrames.entries
        .where((entry) => entry.value.category == category)
        .map((entry) => entry.key)
        .toList();
  }
  static List<String> getAllCategories() {
    return _allFrames.values.map((meta) => meta.category).toSet().toList();
  }
  static List<FrameMeta> getFramesByCategory(String category) {
    return _allFrames.values
        .where((meta) => meta.category == category)
        .toList();
  }
  static int get totalFrameCount => _allFrames.length;
  static Map<String, int> getFrameCountByCategory() {
    final Map<String, int> counts = {};
    for (final meta in _allFrames.values) {
      counts[meta.category] = (counts[meta.category] ?? 0) + 1;
    }
    return counts;
  }
  static final Map<String, FrameMeta> _allFrames = {
    'frame_cal_01': const FrameMeta(
      id: 'frame_cal_01',
      category: 'calligraphy',
      borderWidth: 30,
      cornerSizeMultiplier: 7.6,
      generated: true,
    ),
    'frame_cal_02': const FrameMeta(
      id: 'frame_cal_02',
      category: 'calligraphy',
      borderWidth: 30,
      cornerSizeMultiplier: 7.0,
      generated: true,
    ),
    'frame_cal_03': const FrameMeta(
      id: 'frame_cal_03',
      category: 'calligraphy',
      borderWidth: 30,
      cornerSizeMultiplier: 7.0,
      generated: true,
    ),
    'frame_cal_04': const FrameMeta(
      id: 'frame_cal_04',
      category: 'calligraphy',
      borderWidth: 30,
      cornerSizeMultiplier: 8.0,
      generated: true,
    ),
    'frame_cp_01': const FrameMeta(
      id: 'frame_cp_01',
      category: 'chinese_painting',
      borderWidth: 30,
      cornerSizeMultiplier: 4.0,
      generated: true,
    ),
    'frame_cp_02': const FrameMeta(
      id: 'frame_cp_02',
      category: 'chinese_painting',
      borderWidth: 30,
      cornerSizeMultiplier: 4.0,
      generated: false,
    ),
    'frame_cp_03': const FrameMeta(
      id: 'frame_cp_03',
      category: 'chinese_painting',
      borderWidth: 30,
      cornerSizeMultiplier: 4.0,
      generated: false,
    ),
    'frame_cp_04': const FrameMeta(
      id: 'frame_cp_04',
      category: 'chinese_painting',
      borderWidth: 30,
      cornerSizeMultiplier: 4.0,
      generated: true,
    ),
    'frame_scroll_01': const FrameMeta(
      id: 'frame_scroll_01',
      category: 'scroll',
      borderWidth: 30,
      cornerSizeMultiplier: 6.0,
      generated: true,
    ),
    'frame_scroll_02': const FrameMeta(
      id: 'frame_scroll_02',
      category: 'scroll',
      borderWidth: 30,
      cornerSizeMultiplier: 4.8,
      generated: true,
    ),
    'frame_scroll_03': const FrameMeta(
      id: 'frame_scroll_03',
      category: 'scroll',
      borderWidth: 50,
      cornerSizeMultiplier: 4.2,
      generated: true,
    ),
    'frame_ph_01': const FrameMeta(
      id: 'frame_ph_01',
      category: 'photography',
      borderWidth: 30,
      generated: true,
    ),
    'frame_ph_02': const FrameMeta(
      id: 'frame_ph_02',
      category: 'photography',
      borderWidth: 30,
      generated: true,
    ),
    'frame_ph_03': const FrameMeta(
      id: 'frame_ph_03',
      category: 'photography',
      borderWidth: 30,
      cornerSizeMultiplier: 3.5,
      generated: true,
    ),
    'frame_ph_04': const FrameMeta(
      id: 'frame_ph_04',
      category: 'photography',
      borderWidth: 30,
      cornerSizeMultiplier: 3.5,
      generated: true,
    ),
    'frame_mod_01': const FrameMeta(
      id: 'frame_mod_01',
      category: 'modern',
      borderWidth: 30,
      cornerSizeMultiplier: 9.8,
      generated: true,
    ),
    'frame_mod_02': const FrameMeta(
      id: 'frame_mod_02',
      category: 'modern',
      borderWidth: 30,
      cornerSizeMultiplier: 7.7,
      generated: true,
    ),
    'frame_mod_03': const FrameMeta(
      id: 'frame_mod_03',
      category: 'modern',
      borderWidth: 30,
      cornerSizeMultiplier: 5.0,
      generated: true,
    ),
    'frame_mod_04': const FrameMeta(
      id: 'frame_mod_04',
      category: 'modern',
      borderWidth: 30,
      cornerSizeMultiplier: 9.6,
      generated: true,
    ),
    'frame_oil_01': const FrameMeta(
      id: 'frame_oil_01',
      category: 'oil',
      borderWidth: 30,
      cornerSizeMultiplier: 3.4,
      generated: true,
    ),
    'frame_oil_02': const FrameMeta(
      id: 'frame_oil_02',
      category: 'oil',
      borderWidth: 30,
      cornerSizeMultiplier: 3.2,
      generated: true,
    ),
    'frame_oil_03': const FrameMeta(
      id: 'frame_oil_03',
      category: 'oil',
      borderWidth: 30,
      cornerSizeMultiplier: 3.4,
      generated: true,
    ),
    'frame_oil_04': const FrameMeta(
      id: 'frame_oil_04',
      category: 'oil',
      borderWidth: 30,
      generated: true,
      cornerSizeMultiplier: 3.4,
    ),
    'frame_fa_01': const FrameMeta(
      id: 'frame_fa_01',
      category: 'fine_art',
      borderWidth: 30,
      cornerSizeMultiplier: 4.0,
      generated: true,
    ),
    'frame_fa_02': const FrameMeta(
      id: 'frame_fa_02',
      category: 'fine_art',
      borderWidth: 30,
      generated: true,
    ),
    'frame_fa_03': const FrameMeta(
      id: 'frame_fa_03',
      category: 'fine_art',
      borderWidth: 30,
      cornerSizeMultiplier: 4.3,
      generated: true,
    ),
    'frame_fa_04': const FrameMeta(
      id: 'frame_fa_04',
      category: 'fine_art',
      borderWidth: 30,
      cornerSizeMultiplier: 3.4,
      generated: true,
    ),
    'frame_fa_05': const FrameMeta(
      id: 'frame_fa_05',
      category: 'fine_art',
      borderWidth: 30,
      cornerSizeMultiplier: 4.0,
      generated: true,
    ),
  };
}
class FrameMeta {
  final String id;
  final String category;
  final int borderWidth;
  final bool generated;
  final EdgeDimensions? edges;
  final EdgeInsets? imageInsets;
  final double cornerSizeMultiplier;
  const FrameMeta({
    required this.id,
    required this.category,
    required this.borderWidth,
    this.generated = true,
    this.edges,
    this.imageInsets,
    this.cornerSizeMultiplier = 3.6,
  });
  FrameMeta copyWith({
    String? id,
    String? category,
    int? borderWidth,
    bool? generated,
    EdgeDimensions? edges,
    EdgeInsets? imageInsets,
    double? cornerSizeMultiplier,
  }) {
    return FrameMeta(
      id: id ?? this.id,
      category: category ?? this.category,
      borderWidth: borderWidth ?? this.borderWidth,
      generated: generated ?? this.generated,
      edges: edges ?? this.edges,
      imageInsets: imageInsets ?? this.imageInsets,
      cornerSizeMultiplier: cornerSizeMultiplier ?? this.cornerSizeMultiplier,
    );
  }
}
class EdgeDimensions {
  final int top;
  final int bottom;
  final int left;
  final int right;
  const EdgeDimensions({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
  EdgeDimensions copyWith({
    int? top,
    int? bottom,
    int? left,
    int? right,
  }) {
    return EdgeDimensions(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }
}
