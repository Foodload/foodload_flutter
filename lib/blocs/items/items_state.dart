import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemSendInProgress extends ItemsState {}

class ItemSendSuccess extends ItemsState {}

class ItemSendFailure extends ItemsState {}

//Prob specify fridge, freezer, pantry etc.
class ItemsLoadInProgress extends ItemsState {}

class ItemsLoadSuccess extends ItemsState {
  final List<Item> items;

  const ItemsLoadSuccess({
    this.items,
  });

  ItemsLoadSuccess copyWith({
    List<Item> items,
  }) {
    return ItemsLoadSuccess(
      items: items ?? this.items,
    );
  }

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemsLoadSuccess { items: $items }';
}

class ItemsLoadFailure extends ItemsState {}
