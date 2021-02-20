import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:meta/meta.dart';

@immutable
class TemplateState extends Equatable {
  final Template template;
  final Status status;
  final String errorMessage;

  TemplateState({
    this.template,
    this.status: Status.COMPLETED,
    this.errorMessage,
  });

  TemplateState copyWith(
      {Template template, Status status, String errorMessage}) {
    return TemplateState(
      template: template ?? this.template,
      status: status,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'TemplateState {template: $template, status: $status, errorMessage: $errorMessage}';
  }

  @override
  List<Object> get props => [template, status, errorMessage];
}

class TemplateStateLoading extends TemplateState {
  @override
  String toString() {
    return 'TemplateStateLoading {}';
  }
}
