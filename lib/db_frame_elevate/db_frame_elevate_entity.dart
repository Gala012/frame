class ArtworkEntity {
  final int? id;
  final String thumbnailPath;
  final String outputPath;
  final String featureType;
  final String createdAt;
  final int? outputWidth;
  final int? outputHeight;
  const ArtworkEntity({
    this.id,
    required this.thumbnailPath,
    required this.outputPath,
    required this.featureType,
    required this.createdAt,
    this.outputWidth,
    this.outputHeight,
  });
  factory ArtworkEntity.fromMap(Map<String, dynamic> map) {
    return ArtworkEntity(
      id: map['id'] as int?,
      thumbnailPath: map['thumbnail_path'] as String,
      outputPath: map['output_path'] as String,
      featureType: map['feature_type'] as String,
      createdAt: map['created_at'] as String,
      outputWidth: map['output_width'] as int?,
      outputHeight: map['output_height'] as int?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'thumbnail_path': thumbnailPath,
      'output_path': outputPath,
      'feature_type': featureType,
      'created_at': createdAt,
      'output_width': outputWidth,
      'output_height': outputHeight,
    };
  }
}
class ArtworkSourceEntity {
  final int? id;
  final int artworkId;
  final String sourcePath;
  final double? cropX;
  final double? cropY;
  final double? cropWidth;
  final double? cropHeight;
  final int? rotation;
  final int sortOrder;
  const ArtworkSourceEntity({
    this.id,
    required this.artworkId,
    required this.sourcePath,
    this.cropX,
    this.cropY,
    this.cropWidth,
    this.cropHeight,
    this.rotation,
    this.sortOrder = 0,
  });
  factory ArtworkSourceEntity.fromMap(Map<String, dynamic> map) {
    return ArtworkSourceEntity(
      id: map['id'] as int?,
      artworkId: map['artwork_id'] as int,
      sourcePath: map['source_path'] as String,
      cropX: map['crop_x'] as double?,
      cropY: map['crop_y'] as double?,
      cropWidth: map['crop_width'] as double?,
      cropHeight: map['crop_height'] as double?,
      rotation: map['rotation'] as int?,
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'artwork_id': artworkId,
      'source_path': sourcePath,
      'crop_x': cropX,
      'crop_y': cropY,
      'crop_width': cropWidth,
      'crop_height': cropHeight,
      'rotation': rotation,
      'sort_order': sortOrder,
    };
  }
}
class ArtworkParamsEntity {
  final int? id;
  final int artworkId;
  final String? frameId;
  final String? frameWidth;
  final String? matSize;
  final String? matColor;
  final String? matTexture;
  final String? bgType;
  final String? bgValue;
  final String? filterId;
  final double? filterIntensity;
  final String? sceneId;
  final String? sceneSize;
  final String? sigStyle;
  final String? sigArtist;
  final String? sigTitle;
  final String? sigYear;
  final String? sigMedium;
  final String? sigSize;
  final double? sigX;
  final double? sigY;
  final String? templateId;
  final String? layoutId;
  const ArtworkParamsEntity({
    this.id,
    required this.artworkId,
    this.frameId,
    this.frameWidth,
    this.matSize,
    this.matColor,
    this.matTexture,
    this.bgType,
    this.bgValue,
    this.filterId,
    this.filterIntensity,
    this.sceneId,
    this.sceneSize,
    this.sigStyle,
    this.sigArtist,
    this.sigTitle,
    this.sigYear,
    this.sigMedium,
    this.sigSize,
    this.sigX,
    this.sigY,
    this.templateId,
    this.layoutId,
  });
  factory ArtworkParamsEntity.fromMap(Map<String, dynamic> map) {
    return ArtworkParamsEntity(
      id: map['id'] as int?,
      artworkId: map['artwork_id'] as int,
      frameId: map['frame_id'] as String?,
      frameWidth: map['frame_width'] as String?,
      matSize: map['mat_size'] as String?,
      matColor: map['mat_color'] as String?,
      matTexture: map['mat_texture'] as String?,
      bgType: map['bg_type'] as String?,
      bgValue: map['bg_value'] as String?,
      filterId: map['filter_id'] as String?,
      filterIntensity: map['filter_intensity'] as double?,
      sceneId: map['scene_id'] as String?,
      sceneSize: map['scene_size'] as String?,
      sigStyle: map['sig_style'] as String?,
      sigArtist: map['sig_artist'] as String?,
      sigTitle: map['sig_title'] as String?,
      sigYear: map['sig_year'] as String?,
      sigMedium: map['sig_medium'] as String?,
      sigSize: map['sig_size'] as String?,
      sigX: map['sig_x'] as double?,
      sigY: map['sig_y'] as double?,
      templateId: map['template_id'] as String?,
      layoutId: map['layout_id'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'artwork_id': artworkId,
      'frame_id': frameId,
      'frame_width': frameWidth,
      'mat_size': matSize,
      'mat_color': matColor,
      'mat_texture': matTexture,
      'bg_type': bgType,
      'bg_value': bgValue,
      'filter_id': filterId,
      'filter_intensity': filterIntensity,
      'scene_id': sceneId,
      'scene_size': sceneSize,
      'sig_style': sigStyle,
      'sig_artist': sigArtist,
      'sig_title': sigTitle,
      'sig_year': sigYear,
      'sig_medium': sigMedium,
      'sig_size': sigSize,
      'sig_x': sigX,
      'sig_y': sigY,
      'template_id': templateId,
      'layout_id': layoutId,
    };
  }
}
