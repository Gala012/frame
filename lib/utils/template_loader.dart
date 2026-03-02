import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/template_data.dart';
class TemplateLoader {
  static List<TemplateData>? _cachedTemplates;
  static Future<List<TemplateData>> loadTemplates() async {
    if (_cachedTemplates != null) return _cachedTemplates!;
    final String jsonString =
        await rootBundle.loadString('assets/templates/templates.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _cachedTemplates =
        jsonList.map((json) => TemplateData.fromJson(json)).toList();
    return _cachedTemplates!;
  }
  static List<TemplateData> getTemplatesByCategory(
      List<TemplateData> templates, String categoryKey) {
    return templates
        .where((t) => t.categoryKey == categoryKey)
        .toList();
  }
  static TemplateData? getTemplateById(
      List<TemplateData> templates, String id) {
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
  static void clearCache() {
    _cachedTemplates = null;
  }
}
