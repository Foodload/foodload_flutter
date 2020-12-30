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
  StreamSubscription _itemsSubscription;

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
          await _itemRepository.init(await _userRepository.getToken());
      _itemsSubscription?.cancel();
      _itemsSubscription = _itemRepository
          .itemsStream()
          .listen((items) => add(ItemsUpdated(items)));
      yield ItemsLoadSuccess(items: items);
    } catch (error) {
      print(error);
      yield ItemsLoadFailure();
    }
  }

  Stream<ItemsState> _mapItemsUpdatedToState(ItemsUpdated event) async* {
    final List<Item> updatedItems = event.items;
    yield ItemsLoadSuccess(items: updatedItems);
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _itemsSubscription?.cancel();
    return super.close();
  }
}
