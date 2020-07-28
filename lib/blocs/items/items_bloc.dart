import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/items/items_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository itemRepository;
  final UserRepository userRepository;
  StreamSubscription _itemsSubscription;

  ItemsBloc({
    @required this.itemRepository,
    @required this.userRepository,
  })  : assert(itemRepository != null && userRepository != null),
        super(ItemsLoadInProgress());

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is SendToken) {
      yield ItemSendInProgress();
      try {
        final token = await userRepository.getToken();
        print('From Item Bloc: $token');
        await itemRepository.sendToken(token);
        yield ItemSendSuccess();
      } catch (_) {
        yield ItemSendFailure();
      }
    } else if (event is ItemsLoad) {
      yield* _mapItemsLoadToState();
    } else if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    }
  }

  Stream<ItemsState> _mapItemsLoadToState() async* {
    _itemsSubscription?.cancel();
    _itemsSubscription =
        itemRepository.items().listen((items) => add(ItemsUpdated(items)));

//    try {
//      final itemReps = await itemRepository.getItems();
//      yield ItemsLoadSuccess(items: itemReps);
//    } catch (_) {
//      yield ItemsLoadFailure();
//    }
  }

  Stream<ItemsState> _mapItemsUpdatedToState(ItemsUpdated event) async* {
    yield ItemsLoadSuccess(items: event.items);
  }

  @override
  Future<void> close() {
    _itemsSubscription?.cancel();
    return super.close();
  }
}
