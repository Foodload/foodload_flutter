import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ItemIncrement extends ItemEvent {
  final int id;

  ItemIncrement(this.id);
}

class ItemDecrement extends ItemEvent {
  final int id;

  ItemDecrement(this.id);
}
