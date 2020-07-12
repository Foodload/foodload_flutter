import 'package:foodload_flutter/blocs/item/bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository itemRepository;
  final UserRepository userRepository;

  ItemBloc({
    @required this.itemRepository,
    @required this.userRepository,
  }) : assert(itemRepository != null && userRepository != null);

  @override
  ItemState get initialState => ItemInitial();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
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
    } else if (event is ItemFetched) {
      final itemReps = await itemRepository.getItems();
      yield ItemSuccess(itemRepresentations: itemReps);
      return;
    }
  }
}
