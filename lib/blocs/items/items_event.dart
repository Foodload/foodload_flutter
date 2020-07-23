import 'package:equatable/equatable.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

//For testing
class SendToken extends ItemsEvent {}

class ItemsLoad extends ItemsEvent {}
