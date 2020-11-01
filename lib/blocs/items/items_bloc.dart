import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/items/items_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:meta/meta.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository _itemRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  StreamSubscription _authSubscription;

  ItemsBloc({
    @required itemRepository,
    @required userRepository,
    @required authBloc,
  })  : assert(itemRepository != null &&
            userRepository != null &&
            authBloc != null),
        _itemRepository = itemRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(ItemsLoadInProgress()) {
    _authSubscription = _authBloc.listen((state) {
      if (state is AuthSuccess) {
        add(ItemsLoad());
      }
      if (state is AuthFailure) {
        //TODO: Remove items...?
        print('remove items (ItemsBloc)');
      }
    });
  }

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is ItemsLoad) {
      yield* _mapItemsLoadToState();
    } else if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    }
  }

  Stream<ItemsState> _mapItemsLoadToState() async* {
    try {
      final items =
          await _itemRepository.getItemCounts(await _userRepository.getToken());
      yield ItemsLoadSuccess(items: items);
      _itemRepository.setOnUpdateItem(
          (Item updatedItem) => add(ItemsUpdated(updatedItem)));
    } catch (_) {
      yield ItemsLoadFailure();
    }
  }

  Stream<ItemsState> _mapItemsUpdatedToState(ItemsUpdated event) async* {
    final items = (state as ItemsLoadSuccess).items;

    final itemIdx = items.lastIndexWhere((item) => item.id == event.item.id);
    final newItems = [...items];
    if (itemIdx == -1) {
      //TODO: Needs testing with adding new item
      newItems.add(event.item);
      yield ItemsLoadSuccess(items: newItems);
      return;
    }

    newItems.removeAt(itemIdx);
    newItems.insert(itemIdx, event.item);
    yield ItemsLoadSuccess(items: newItems);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
