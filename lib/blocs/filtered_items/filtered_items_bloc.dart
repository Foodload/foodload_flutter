import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:foodload_flutter/blocs/filtered_items/filtered_items.dart';
import 'package:foodload_flutter/blocs/items/items_bloc.dart';
import 'package:foodload_flutter/blocs/items/items_state.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:foodload_flutter/models/search_filter.dart';
import 'package:meta/meta.dart';

class FilteredItemsBloc extends Bloc<FilteredItemsEvent, FilteredItemsState> {
  final ItemsBloc itemsBloc;
  StreamSubscription itemsSubscription;

  FilteredItemsBloc({@required this.itemsBloc})
      : super(
          itemsBloc.state is ItemsLoadSuccess
              ? FilteredItemsLoadSuccess(
                  (itemsBloc.state as ItemsLoadSuccess).items, SearchFilter.all)
              : FilteredItemsLoadInProgress(),
        ) {
    itemsSubscription = itemsBloc.listen((state) {
      if (state is ItemsLoadSuccess) {
        add(ItemsUpdated((itemsBloc.state as ItemsLoadSuccess).items));
      }
    });
  }

  @override
  Stream<Transition<FilteredItemsEvent, FilteredItemsState>> transformEvents(
    Stream<FilteredItemsEvent> events,
    TransitionFunction<FilteredItemsEvent, FilteredItemsState> transFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! FilterUpdated);
    });
    final debounceStream = events.where((event) {
      return (event is FilterUpdated);
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transFn,
    );
  }

  @override
  Stream<FilteredItemsState> mapEventToState(FilteredItemsEvent event) async* {
    if (event is FilterUpdated) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    }
  }

  Stream<FilteredItemsState> _mapUpdateFilterToState(
      FilterUpdated event) async* {
    if (itemsBloc.state is ItemsLoadSuccess) {
      yield FilteredItemsLoadSuccess(
        _mapItemsToFilteredItems(
          (itemsBloc.state as ItemsLoadSuccess).items,
          event.filter,
        ),
        event.filter,
      );
    }
  }

  Stream<FilteredItemsState> _mapItemsUpdatedToState(
      ItemsUpdated event) async* {
    final searchFilter = state is FilteredItemsLoadSuccess
        ? (state as FilteredItemsLoadSuccess).filter
        : SearchFilter.all;
    yield FilteredItemsLoadSuccess(
      _mapItemsToFilteredItems(
          (itemsBloc.state as ItemsLoadSuccess).items, searchFilter),
      searchFilter,
    );
  }

  List<Item> _mapItemsToFilteredItems(List<Item> items, var filter) {
    return items.where((item) {
      if (filter == SearchFilter.all ||
          filter == null ||
          filter.toString().trim().isEmpty) {
        return true;
      } else {
        return item.title
            .toLowerCase()
            .contains(filter.toString().trim().toLowerCase());
      }
    }).toList();
  }

  @override
  Future<void> close() {
    itemsSubscription.cancel();
    return super.close();
  }
}
