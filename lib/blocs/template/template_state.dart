import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/helpers/error_handler/model/status.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:meta/meta.dart';

@immutable
class TemplateState extends Equatable {
  final Template template;

  TemplateState({
    this.template,
  });

  TemplateState copyWith({
    template,
    int amount,
    bool validAmount,
    Status addStatus,
  }) {
    return TemplateState(
      template: template ?? this.template,
    );
  }

  @override
  String toString() {
    return 'TemplateState {template: $template}';
  }

  @override
  List<Object> get props => [template];
}

class TemplateStateLoading extends TemplateState {
  @override
  String toString() {
    return 'TemplateStateLoading {}';
  }
}
