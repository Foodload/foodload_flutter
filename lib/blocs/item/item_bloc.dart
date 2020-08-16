import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item/item.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository _itemRepository;
  final UserRepository _userRepository;

  ItemBloc({
    @required ItemRepository itemRepository,
    @required UserRepository userRepository,
  })  : assert(itemRepository != null && userRepository != null),
        _itemRepository = itemRepository,
        _userRepository = userRepository,
        super(ItemInit());

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is ItemIncrement) {
      yield* _mapItemAddToState(event);
    }
  }

  Stream<ItemState> _mapItemAddToState(ItemIncrement event) async* {
    try {
      await _itemRepository.incrementItem(
          await _userRepository.getToken(), event.id);
      yield ItemSuccess();
    } catch (error) {
      yield ItemFailure();
    }
  }
}
