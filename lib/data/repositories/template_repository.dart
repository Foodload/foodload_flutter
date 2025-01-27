import 'package:foodload_flutter/data/providers/foodload_api_client.dart';
import 'package:foodload_flutter/models/buy_item.dart';
import 'package:foodload_flutter/models/exceptions/not_found_exception.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/models/template_item.dart';
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
    } else if (!refresh && _templates == null) {
      return null;
    }
    final respJson = await _foodloadApiClient.getTemplates(token);
    List<Template> templates = (respJson as List)
        .map((jsonTemplate) => Template.fromJson(jsonTemplate))
        .toList();
    _templates = templates;
    return [..._templates];
  }

  Future<Template> getTemplate(int templateId,
      {String token, bool refresh: false}) async {
    if (!refresh && _templates != null) {
      Template template =
          _templates.firstWhere((template) => template.id == templateId);
      if (template != null) {
        return template.copyWith();
      }
      return null;
    } else if (!refresh && _templates == null) {
      return null;
    }
    //TODO: Implement API and API call.
    return null;
  }

  Future<Template> createTemplate({String token, String name}) async {
    Map<String, dynamic> body = {
      'name': name,
    };
    final respJson = await _foodloadApiClient.createTemplate(token, body);
    final Template template = Template.fromJson(respJson);
    _templates.add(template);
    return template;
  }

  Future<TemplateItem> addTemplateItemToTemplate(
      String token, int templateId, int itemId, int amount) async {
    final respJson = await _foodloadApiClient.addTemplateItemToTemplate(
        token, templateId, itemId, amount);
    final TemplateItem templateItem = TemplateItem.fromJson(respJson);
    _addTemplateItemToTemplate(templateItem, templateId);
    return templateItem;
  }

  Future<void> updateTemplateItem({
    @required String token,
    @required int templateId,
    @required int templateItemId,
    @required int newAmount,
  }) async {
    await _foodloadApiClient.updateTemplateItem(
        token: token,
        templateId: templateId,
        templateItemId: templateItemId,
        newAmount: newAmount);
    _updateTemplateItem(templateId, templateItemId, newAmount);
  }

  Future<void> deleteTemplate(String token, int templateId) async {
    await _foodloadApiClient.deleteTemplate(token, templateId);
    _removeTemplate(templateId);
  }

  Future<List<BuyItem>> getBuyList(String token, int templateId) async {
    final respJson = await _foodloadApiClient.getBuyList(token, templateId);
    List<BuyItem> buyList = (respJson['buyList'] as List)
        .map((buyItem) => BuyItem.fromJson(buyItem))
        .toList();
    return buyList;
  }

  Future<void> deleteTemplateItem(
      String token, int templateId, int templateItemId) async {
    await _foodloadApiClient.removeTemplateItem(
        token, templateId, templateItemId);
    _removeTemplateItemFromTemplate(templateId, templateItemId);
  }

  void _removeTemplate(int id) {
    final List<Template> newTemplates =
        _templates.where((template) => template.id != id).toList();
    _templates = newTemplates;
  }

  void _updateTemplateItem(int templateId, int templateItemId, int newAmount) {
    final templateIdx =
        _templates.lastIndexWhere((template) => template.id == templateId);
    if (templateIdx == -1) {
      throw NotFoundException(message: 'The template could not be found.');
    } else {
      final oldTemplate = _templates.elementAt(templateIdx);
      final updatedTemplate =
          oldTemplate.updateTemplateItem(templateItemId, newAmount);
      _templates.removeAt(templateIdx);
      _templates.insert(templateIdx, updatedTemplate);
    }
  }

  void _addTemplateItemToTemplate(TemplateItem templateItem, int templateId) {
    final templateIdx =
        _templates.lastIndexWhere((template) => template.id == templateId);
    if (templateIdx == -1) {
      throw NotFoundException(message: 'The template could not be found.');
    } else {
      final oldTemplate = _templates.elementAt(templateIdx);
      final updatedTemplate = oldTemplate.addTemplateItem(templateItem);
      _templates.removeAt(templateIdx);
      _templates.insert(templateIdx, updatedTemplate);
    }
  }

  void _removeTemplateItemFromTemplate(int templateId, int templateItemId) {
    final templateIdx =
        _templates.lastIndexWhere((template) => template.id == templateId);
    if (templateIdx == -1) {
      throw NotFoundException(message: 'The template could not be found.');
    } else {
      final oldTemplate = _templates[templateIdx];
      final updatedTemplate = oldTemplate.removeTemplateItem(templateItemId);
      _templates.removeAt(templateIdx);
      _templates.insert(templateIdx, updatedTemplate);
    }
  }
}
