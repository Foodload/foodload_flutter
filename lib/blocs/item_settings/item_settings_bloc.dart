import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/field_validation.dart';
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
    //TODO: Add set loading state
    if (!FieldValidation.isInteger(event.newAmount)) {
      //TODO: Handle non-integer amount
      print("not an integer");
      return;
    }
    final newAmount = int.parse(event.newAmount);
    try {
      final updatedItemInfo = await _itemRepository.updateItemAmount(
        token: await _userRepository.getToken(),
        id: state.item.id,
        oldAmount: state.item.amount,
        newAmount: newAmount,
      );

      final currItem = state.item.copyWith(amount: updatedItemInfo.amount);
      yield ItemSettingsUpdateAmountSuccess(currItem);
    } catch (error) {
      //TODO: Handle error
      print("Update Amount Bloc Error");
      print(error);
    }
  }

  Stream<ItemSettingsState> _mapMoveToOtherStorageEventToState(
      ItemSettingsMoveToOtherStorage event) async* {
    if (state.item.amount == 0) {
      //TODO: Cannot move when already empty.
      return;
    }

    final updatedItemInfo = await _itemRepository.moveItemToStorage(
        token: await _userRepository.getToken(),
        id: state.item.id,
        moveAmount: 1,
        oldAmount: state.item.amount,
        storageType: event.storage);

    //TODO: Old amount must be given and compared with in backend, if same OK; otherwise 400 and return updated ver
    final currItem = state.item.copyWith(amount: updatedItemInfo.amount);
    yield ItemSettingsMoveFinish(currItem);
  }

  Stream<ItemSettingsState> _mapMoveFromOtherStorageEventToState(
      ItemSettingsMoveFromOtherStorage event) async* {
    if (state.item.amount == 9999) {
      //TODO: Cannot increase more than this??
      return;
    }

    final updatedItemInfo = await _itemRepository.moveItemFromStorage(
        token: await _userRepository.getToken(),
        id: state.item.id,
        moveAmount: 1,
        oldAmount: state.item.amount,
        storageType: event.storage);

    final currItem = state.item.copyWith(amount: updatedItemInfo.amount);
    yield ItemSettingsMoveFinish(currItem);
    //TODO: Old amount must be given and compared with in backend, if same OK; otherwise 400 and return updated ver
  }

  Stream<ItemSettingsState> _mapDeleteToState(ItemSettingsDelete event) async* {
    yield ItemSettingsDeleting(state.item);
    try {
      await _itemRepository.deleteItem(
          token: await _userRepository.getToken(),
          id: state.item.id,
          amount: state.item.amount);
      yield ItemSettingsDeleteSuccess(
          state.item, 'The item was successfully deleted');
    } catch (error) {
      //TODO: Handle error
      print(error);
    }
  }

  Stream<ItemSettingsState> _mapSetInitToState(
      ItemSettingsSetInit event) async* {
    yield ItemSettingsInit(state.item);
  }
}
