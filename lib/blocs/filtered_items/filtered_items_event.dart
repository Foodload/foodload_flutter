import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class FilteredItemsEvent extends Equatable {
  const FilteredItemsEvent();
}

class FilterUpdated extends FilteredItemsEvent {
  final String filter;

  const FilterUpdated(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class ItemsUpdated extends FilteredItemsEvent {
  final List<Item> items;

  const ItemsUpdated(this.items);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemsUpdated { items: $items }';
}
