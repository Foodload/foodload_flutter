import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class ItemsLoad extends ItemsEvent {}

class ItemsUpdated extends ItemsEvent {
  final Item item;

  const ItemsUpdated(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'ItemsUpdated  { item: $item }';
}
