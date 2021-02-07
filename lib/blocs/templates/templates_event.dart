import 'package:equatable/equatable.dart';

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

class UndoDeleteTemplate extends TemplatesEvent {
  UndoDeleteTemplate();

  @override
  String toString() => 'UndoDeleteTemplate {}';
}
