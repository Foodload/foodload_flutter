import 'package:equatable/equatable.dart';
import 'package:foodload_flutter/models/item.dart';

abstract class FilteredItemsState extends Equatable {
  const FilteredItemsState();

  @override
  List<Object> get props => [];
}

class FilteredItemsLoadInProgress extends FilteredItemsState {}

class FilteredItemsLoadSuccess extends FilteredItemsState {
  final List<Item> filteredItems;
  final filter;

  const FilteredItemsLoadSuccess(
    this.filteredItems,
    this.filter,
  );

  @override
  List<Object> get props => [
        filteredItems,
        filter,
      ];

  @override
  String toString() {
    return 'FilteredItemsLoadSuccess { filteredItems: $filteredItems, filter: $filter }';
  }
}
