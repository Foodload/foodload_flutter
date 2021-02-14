import 'package:equatable/equatable.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object> get props => [];
}

class TemplateItemAdded extends TemplateEvent {
  @override
  String toString() => 'TemplateItemAdded {}';
}

class FetchTemplate extends TemplateEvent {
  final int templateId;

  const FetchTemplate(this.templateId);

  @override
  String toString() => 'FetchTemplate {templateId: $templateId}';
}

class DeleteTemplateItemFromState extends TemplateEvent {
  final int templateItemId;

  const DeleteTemplateItemFromState(this.templateItemId);

  @override
  String toString() =>
      'DeleteTemplateItemFromState {templateItemId: $templateItemId}';
}

class DeleteTemplateItem extends TemplateEvent {
  final int templateItemId;

  const DeleteTemplateItem(this.templateItemId);

  @override
  String toString() => 'DeleteTemplateItem {templateItemId: $templateItemId}';
}

class UndoDeleteTemplateItem extends TemplateEvent {
  @override
  String toString() => 'UndoDeleteTemplateItem {}';
}

class UpdateTemplateItem extends TemplateEvent {
  final int templateItemId;
  final int newAmount;

  const UpdateTemplateItem(this.templateItemId, this.newAmount);

  @override
  String toString() => 'UpdateTemplateItem {}';
}
