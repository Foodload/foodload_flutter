import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/data/providers/socket_client.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/item_info.dart';
import 'package:foodload_flutter/models/items.dart';
import 'package:foodload_flutter/models/item_updated_info.dart';
import 'package:meta/meta.dart';

class TemplateRepository {
  final FoodloadApiClient _foodloadApiClient;

  List<Template> _templates;

  TemplateRepository({@required foodloadApiClient})
      : assert(foodloadApiClient != null),
        _foodloadApiClient = foodloadApiClient;

  Future<List<Template>> getTemplates(
      {String token, bool refresh: false}) async {
    if (!refresh && _templates != null) {
      return [..._templates];
    }
    final respJson = await _foodloadApiClient.getTemplates(token);
    List<Template> templates = (respJson as List)
        .map((jsonTemplate) => Template.fromJson(jsonTemplate))
        .toList();
    _templates = templates;
    return [..._templates];
  }

  Future<dynamic> createTemplate(
      String token, Map<String, dynamic> body) async {
    return await _foodloadApiClient.createTemplate(token, body);
  }

  Future<dynamic> addTemplateItemToTemplate(
      String token, int templateId, Map<String, dynamic> body) async {
    return await _foodloadApiClient.addTemplateItemToTemplate(
        token, templateId, body);
  }

  Future<dynamic> updateTemplateItem(
    String token,
    Map<String, dynamic> body,
  ) async {
    return await _foodloadApiClient.updateTemplateItem(token, body);
  }

  Future<dynamic> removeTemplateItem(
      String token, int templateId, int templateItemId) async {
    return await _foodloadApiClient.removeTemplateItem(
        token, templateId, templateItemId);
  }

  Future<void> deleteTemplate(String token, int templateId) async {
    await _foodloadApiClient.deleteTemplate(token, templateId);
  }

  Future<dynamic> getBuyList(String token, int templateId) async {
    return await _foodloadApiClient.getBuyList(token, templateId);
  }
}
