//import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/items/items_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:meta/meta.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository itemRepository;
  final UserRepository userRepository;
  //StreamSubscription _updateItemSubscription;

  ItemsBloc({
    @required this.itemRepository,
    @required this.userRepository,
  })  : assert(itemRepository != null && userRepository != null),
        super(ItemsLoadInProgress());

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
//    if (event is SendToken) {
//      yield ItemSendInProgress();
//      try {
//        final token = await userRepository.getToken();
//        print('From Item Bloc: $token');
//        await itemRepository.sendToken(token);
//        yield ItemSendSuccess();
//      } catch (_) {
//        yield ItemSendFailure();
//      }
//    }
    if (event is ItemsLoad) {
      yield* _mapItemsLoadToState();
    } else if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    }
  }

  Stream<ItemsState> _mapItemsLoadToState() async* {
//    _updateItemSubscription?.cancel();
//    _updateItemSubscription = itemRepository
//        .updateItem(data)
//        .listen((items) => add(ItemsUpdated(items)));

    try {
      final items = await itemRepository.getItems();
      yield ItemsLoadSuccess(items: items);
      itemRepository.setOnUpdateItem(
          (Item updatedItem) => add(ItemsUpdated(updatedItem)));
    } catch (_) {
      yield ItemsLoadFailure();
    }
  }

  Stream<ItemsState> _mapItemsUpdatedToState(ItemsUpdated event) async* {
    final items = (state as ItemsLoadSuccess).items;

    final itemIdx = items.lastIndexWhere((item) => item.id == event.item.id);
    if (itemIdx == -1) {
      items.add(event.item);
      yield ItemsLoadSuccess(items: items);
      return;
    }

    items.removeAt(itemIdx);
    items.insert(itemIdx, event.item);
    yield ItemsLoadSuccess(items: items);
  }

  @override
  Future<void> close() {
//    _itemsSubscription?.cancel();
    print("removing setonupdateitem");
    itemRepository.setOnUpdateItem(null);
    return super.close();
  }
}
