import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/template.dart';

abstract class AddNewTemplateState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNewTemplateInit extends AddNewTemplateState {}

class AddNewTemplateAdding extends AddNewTemplateState {}

class AddNewTemplateSuccess extends AddNewTemplateState {
  final Template newTemplate;

  AddNewTemplateSuccess(this.newTemplate);

  @override
  List<Object> get props => [newTemplate];
}

class AddNewTemplateFail extends AddNewTemplateState {
  final String errorMessage;

  AddNewTemplateFail(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
