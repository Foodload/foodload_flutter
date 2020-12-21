import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/models/item.dart';
import 'package:meta/meta.dart';

class ItemSettingsBloc extends Bloc<ItemSettingsEvent, ItemSettingsState> {
  final ItemRepository _itemRepository;
  final UserRepository _userRepository;

  ItemSettingsBloc({
    @required ItemRepository itemRepository,
    @required UserRepository userRepository,
    @required Item item,
  })  : assert(itemRepository != null && userRepository != null),
        _itemRepository = itemRepository,
        _userRepository = userRepository,
        super(ItemSettingsInit(item));

  @override
  Stream<ItemSettingsState> mapEventToState(ItemSettingsEvent event) async* {
    if (event is ItemSettingsUpdateAmount) {
      yield* _mapUpdateAmountToState(event);
    } else if (event is ItemSettingsMoveToOtherStorage) {
      yield* _mapMoveToOtherStorageEventToState(event);
    } else if (event is ItemSettingsMoveFromOtherStorage) {
      yield* _mapMoveFromOtherStorageEventToState(event);
    } else if (event is ItemSettingsDelete) {
      yield* _mapDeleteToState(event);
    } else if (event is ItemSettingsSetInit) {
      yield* _mapSetInitToState(event);
    }
  }

  Stream<ItemSettingsState> _mapUpdateAmountToState(
      ItemSettingsUpdateAmount event) async* {
    print("Update Amount");
    //TODO: Old amount must be given and compared with in backend, if same OK; otherwise 400 and return updated ver
  }

  Stream<ItemSettingsState> _mapMoveToOtherStorageEventToState(
      ItemSettingsMoveToOtherStorage event) async* {
    if (state.item.amount == 0) {
      //TODO: Cannot move when already empty.
      return;
    }

    final moveItemInfo = await _itemRepository.moveItemToStorage(
        token: await _userRepository.getToken(),
        id: state.item.id,
        moveAmount: 1,
        oldAmount: state.item.amount,
        storageType: event.storage);

    print(moveItemInfo);
    //TODO: Old amount must be given and compared with in backend, if same OK; otherwise 400 and return updated ver
    final currItem = state.item.copyWith(amount: moveItemInfo.amount);
    yield ItemSettingsMoveFinish(currItem);
  }

  Stream<ItemSettingsState> _mapMoveFromOtherStorageEventToState(
      ItemSettingsMoveFromOtherStorage event) async* {
    if (state.item.amount == 9999) {
      //TODO: Cannot increase more than this??
      return;
    }

    final moveItemInfo = await _itemRepository.moveItemFromStorage(
        token: await _userRepository.getToken(),
        id: state.item.id,
        moveAmount: 1,
        oldAmount: state.item.amount,
        storageType: event.storage);

    print(moveItemInfo);
    final currItem = state.item.copyWith(amount: moveItemInfo.amount);
    yield ItemSettingsMoveFinish(currItem);
    //TODO: Old amount must be given and compared with in backend, if same OK; otherwise 400 and return updated ver
  }

  Stream<ItemSettingsState> _mapDeleteToState(ItemSettingsDelete event) async* {
    yield ItemSettingsDeleting(state.item);
    print("Deleting...");
    //TODO: API call
    yield ItemSettingsDeleteSuccess(
        state.item, 'The item was successfully deleted');
  }

  Stream<ItemSettingsState> _mapSetInitToState(
      ItemSettingsSetInit event) async* {
    yield ItemSettingsInit(state.item);
  }
}
