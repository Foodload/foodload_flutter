import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class ItemsLoad extends ItemsEvent {}

class ItemsUpdated extends ItemsEvent {
  final List<Item> items;

  const ItemsUpdated(this.items);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemsUpdated  { items: $items }';
}

class ItemsDeleted extends ItemsEvent {
  final List<int> itemIds;

  const ItemsDeleted(this.itemIds);

  @override
  List<Object> get props => [itemIds];

  @override
  String toString() => 'ItemsDeleted  { itemIds: $itemIds }';
}
