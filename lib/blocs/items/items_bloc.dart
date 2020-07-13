import 'package:foodload_flutter/blocs/items/items.dart';
import 'package:foodload_flutter/blocs/items/items_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class ItemsBloc extends Bloc<ItemEvent, ItemsState> {
  final ItemRepository itemRepository;
  final UserRepository userRepository;

  ItemsBloc({
    @required this.itemRepository,
    @required this.userRepository,
  })  : assert(itemRepository != null && userRepository != null),
        super(ItemsLoadInProgress());

  @override
  Stream<ItemsState> mapEventToState(ItemEvent event) async* {
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
      yield* _mapItemsLoadedToState();
    }
  }

  Stream<ItemsState> _mapItemsLoadedToState() async* {
    try {
      final itemReps = await itemRepository.getItems();
      yield ItemsLoadSuccess(items: itemReps);
    } catch (_) {
      yield ItemsLoadFailure();
    }
  }
}
