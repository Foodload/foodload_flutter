import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

//For testing
class SendToken extends ItemEvent {}

class ItemFetched extends ItemEvent {}
