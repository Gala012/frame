import 'package:flutter/material.dart';
class TemplateData {
  final String id;
  final String name;
  final String category;
  final String categoryKey;
  final String? frame;
  final MatConfig mat;
  final BackgroundConfig background;
  TemplateData({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryKey,
    this.frame,
    required this.mat,
    required this.background,
  });
  factory TemplateData.fromJson(Map<String, dynamic> json) {
    return TemplateData(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      categoryKey: json['category_key'] as String,
      frame: json['frame'] as String?,
      mat: MatConfig.fromJson(json['mat'] as Map<String, dynamic>),
      background:
          BackgroundConfig.fromJson(json['background'] as Map<String, dynamic>),
    );
  }
  String get previewPath {
    return 'assets/templates/$categoryKey/${id}_preview.jpg';
  }
  bool get hasPreview => true;
}
class MatConfig {
  final String size;
  final String color;
  final String? texture;
  MatConfig({
    required this.size,
    required this.color,
    this.texture,
  });
  factory MatConfig.fromJson(Map<String, dynamic> json) {
    return MatConfig(
      size: json['size'] as String,
      color: json['color'] as String,
      texture: json['texture'] as String?,
    );
  }
  Color get colorValue => _hexToColor(color);
  static Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
class BackgroundConfig {
  final String type;
  final String? color;
  final String? texture;
  BackgroundConfig({
    required this.type,
    this.color,
    this.texture,
  });
  factory BackgroundConfig.fromJson(Map<String, dynamic> json) {
    return BackgroundConfig(
      type: json['type'] as String,
      color: json['color'] as String?,
      texture: json['texture'] as String?,
    );
  }
  Color? get colorValue => color != null ? _hexToColor(color!) : null;
  static Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
