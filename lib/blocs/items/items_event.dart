import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

//For testing
class SendToken extends ItemEvent {}

class ItemsLoad extends ItemEvent {}
