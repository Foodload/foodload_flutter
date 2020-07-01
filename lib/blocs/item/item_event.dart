import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class SendToken extends ItemEvent {
  const SendToken();

  @override
  List<Object> get props => [];
}
