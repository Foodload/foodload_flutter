import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings.dart';
import 'package:foodload_flutter/blocs/item_settings/item_settings_state.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/field_validation.dart';
import 'package:foodload_flutter/models/enums/action_error.dart';
import 'package:foodload_flutter/models/enums/field_error.dart';
import 'package:foodload_flutter/models/enums/status.dart';
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
        super(ItemSettingsState(item: item));

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
    yield state.copyWith(amountStatus: Status.LOADING);
    if (!FieldValidation.isInteger(event.newAmount)) {
      yield state.copyWith(
          amountError: FieldError.Invalid, amountStatus: Status.ERROR);
      return;
    }
    final newAmount = int.parse(event.newAmount);
    if (FieldValidation.isAmountOverflow(newAmount)) {
      yield state.copyWith(
          amountError: FieldError.AmountOverflow, amountStatus: Status.ERROR);
      return;
    } else if (newAmount < 0) {
      yield state.copyWith(
          amountError: FieldError.NegativeAmount, amountStatus: Status.ERROR);
      return;
    }
    if (!_isItemUpToDate()) {
      final updatedItem = _getUpdateItem();
      yield state.copyWith(item: updatedItem, itemStatus: Status.OUT_OF_DATE);
      return;
    }
    try {
      final updatedItemInfo = await _itemRepository.updateItemAmount(
        token: await _userRepository.getToken(),
        id: state.item.id,
        oldAmount: state.item.amount,
        newAmount: newAmount,
      );
      final currItem = state.item.copyWith(amount: updatedItemInfo.amount);
      yield state.copyWith(item: currItem, amountStatus: Status.COMPLETED);
    } catch (error) {
      //TODO: Handle API error
      print(error);
    }
  }

  Stream<ItemSettingsState> _mapMoveToOtherStorageEventToState(
      ItemSettingsMoveToOtherStorage event) async* {
    if (!_isItemUpToDate()) {
      final updatedItem = _getUpdateItem();
      yield state.copyWith(item: updatedItem, itemStatus: Status.OUT_OF_DATE);
      return;
    }
    if (state.item.amount == 0) {
      yield state.copyWith(
        moveStatus: Status.ERROR,
        moveActionError: ActionError.Empty,
      );
      return;
    }

    try {
      final updatedItemInfo = await _itemRepository.moveItemToStorage(
          token: await _userRepository.getToken(),
          id: state.item.id,
          moveAmount: 1,
          oldAmount: state.item.amount,
          storageType: event.storage);

      final currItem = state.item.copyWith(amount: updatedItemInfo.amount);
      yield state.copyWith(item: currItem, moveStatus: Status.COMPLETED);
    } catch (error) {
      //TODO: Add API error handling
      print(error);
    }
  }

  Stream<ItemSettingsState> _mapMoveFromOtherStorageEventToState(
      ItemSettingsMoveFromOtherStorage event) async* {
    if (!_isItemUpToDate()) {
      final updatedItem = _getUpdateItem();
      yield state.copyWith(item: updatedItem, itemStatus: Status.OUT_OF_DATE);
      return;
    }
    if (state.item.amount == FieldValidation.MAX_AMOUNT) {
      yield state.copyWith(
        moveStatus: Status.ERROR,
        moveActionError: ActionError.Overflow,
      );
      return;
    }

    try {
      final updatedItemInfo = await _itemRepository.moveItemFromStorage(
          token: await _userRepository.getToken(),
          id: state.item.id,
          moveAmount: 1,
          oldAmount: state.item.amount,
          storageType: event.storage);

      final currItem = state.item.copyWith(amount: updatedItemInfo.amount);
      yield state.copyWith(item: currItem, moveStatus: Status.COMPLETED);
    } catch (error) {
      //TODO: Add api error handling
      print(error);
    }
  }

  Stream<ItemSettingsState> _mapDeleteToState(ItemSettingsDelete event) async* {
    if (!_isItemUpToDate()) {
      final updatedItem = _getUpdateItem();
      yield state.copyWith(item: updatedItem, itemStatus: Status.OUT_OF_DATE);
      return;
    }
    yield state.copyWith(deleteStatus: Status.LOADING);
    try {
      await _itemRepository.deleteItem(
          token: await _userRepository.getToken(),
          id: state.item.id,
          amount: state.item.amount);
      yield state.copyWith(deleteStatus: Status.COMPLETED);
    } catch (error) {
      //TODO: Handle api error
      print(error);
    }
  }

  Stream<ItemSettingsState> _mapSetInitToState(
      ItemSettingsSetInit event) async* {
    yield state.copyWith(item: state.item);
  }

  bool _isItemUpToDate() {
    final stateItem = state.item;
    final currUpdatedItem = _itemRepository.items().getItem(stateItem.id);
    return currUpdatedItem.amount == stateItem.amount;
  }

  Item _getUpdateItem() {
    return _itemRepository.items().getItem(state.item.id);
  }
}
