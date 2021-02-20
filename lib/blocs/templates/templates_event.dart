import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/template.dart';

abstract class TemplatesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTemplates extends TemplatesEvent {
  FetchTemplates();

  @override
  String toString() => 'FetchTemplates {}';
}

class RefreshTemplates extends TemplatesEvent {
  RefreshTemplates();

  @override
  String toString() => 'RefreshTemplates {}';
}

class DeleteTemplate extends TemplatesEvent {
  final int templateId;

  DeleteTemplate(this.templateId);

  @override
  String toString() => 'DeleteTemplate { templateId: $templateId }';

  @override
  List<Object> get props => [templateId];
}

class DeleteTemplateFromList extends TemplatesEvent {
  final int templateId;

  DeleteTemplateFromList(this.templateId);

  @override
  String toString() => 'DeleteTemplateFromList { templateId: $templateId }';

  @override
  List<Object> get props => [templateId];
}

class AddNewTemplateToList extends TemplatesEvent {
  final Template newTemplate;

  AddNewTemplateToList(this.newTemplate);

  @override
  String toString() => 'AddNewTemplateToList { newTemplate: $newTemplate }';

  @override
  List<Object> get props => [newTemplate];
}

class UndoDeleteTemplate extends TemplatesEvent {
  UndoDeleteTemplate();

  @override
  String toString() => 'UndoDeleteTemplate {}';
}
