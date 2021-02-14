import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:meta/meta.dart';

@immutable
class Template extends Equatable {
  final int id;
  final String name;
  final List<TemplateItem> _templateItems;
  List<TemplateItem> get templateItems => List.unmodifiable(_templateItems);

  const Template(
      {@required this.id, @required this.name, @required templateItems})
      : _templateItems = templateItems;

  Template.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        _templateItems = (json['templateItems'] as List)
            .map((templateItemJson) => TemplateItem.fromJson(templateItemJson))
            .toList();

  Template copyWith({int id, String name, List<TemplateItem> templateItems}) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      templateItems: templateItems ?? this._templateItems,
    );
  }

  Template addTemplateItem(TemplateItem templateItem) {
    return copyWith(templateItems: _templateItems.toList()..add(templateItem));
  }

  Template removeTemplateItem(int templateItemId) {
    final updatedTemplateItems = _templateItems
        .where((templateItem) => templateItem.id != templateItemId)
        .toList();
    return copyWith(templateItems: updatedTemplateItems);
  }

  Template updateTemplateItem(int templateItemId, int newAmount) {
    final templateItemIdx = _templateItems
        .lastIndexWhere((templateItem) => templateItem.id == templateItemId);
    if (templateItemIdx == -1) {
      return null;
    }

    final oldTemplateItem = _templateItems[templateItemIdx];
    final updatedTemplateItem = oldTemplateItem.copyWith(count: newAmount);
    final updateTemplateItems = _templateItems.toList();
    updateTemplateItems.removeAt(templateItemIdx);
    updateTemplateItems.insert(templateItemIdx, updatedTemplateItem);
    return copyWith(templateItems: updateTemplateItems);
  }

  @override
  List<Object> get props => [id, name, _templateItems];

  @override
  String toString() =>
      'Template {id: $id, name: $name, templateItems: $_templateItems}';
}
