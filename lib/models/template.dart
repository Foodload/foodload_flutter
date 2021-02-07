import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:meta/meta.dart';

class Template extends Equatable {
  final int id;
  final String name;
  final List<TemplateItem> templateItems;

  const Template(
      {@required this.id, @required this.name, @required this.templateItems});

  Template.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        templateItems = (json['templateItems'] as List)
            .map((templateItemJson) => TemplateItem.fromJson(templateItemJson))
            .toList();

  @override
  List<Object> get props => [id, name, templateItems];

  @override
  String toString() =>
      'Template {id: $id, name: $name, templateItems: $templateItems}';
}
