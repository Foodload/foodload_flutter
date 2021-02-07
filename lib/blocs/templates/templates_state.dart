import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/models/enums/status.dart';

class TemplatesState extends Equatable {
  final Status templatesStatus;
  final String templatesErrorMessage;
  final List<Template> templates;

  TemplatesState(
      {this.templatesStatus, this.templates, this.templatesErrorMessage});

  TemplatesState copyWith({
    Status templatesStatus,
    List<Template> templates,
    String templatesErrorMessage,
  }) {
    return TemplatesState(
      templatesStatus: templatesStatus,
      templates: templates ?? this.templates,
      templatesErrorMessage: templatesErrorMessage,
    );
  }

  @override
  List<Object> get props => [templatesStatus, templates, templatesErrorMessage];

  @override
  String toString() {
    return 'TemplatesState {templatesStatus: $templatesStatus, templates: $templates, templatesErrorMessage: $templatesErrorMessage}';
  }
}
