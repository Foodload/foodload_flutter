import 'package:equatable/equatable.dart';

abstract class AddNewTemplateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNewTemplate extends AddNewTemplateEvent {
  final String name;

  AddNewTemplate(this.name);
}
