import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:foodload_flutter/blocs/add_item_form/add_item_form.dart';

class AddItemFormBloc extends Bloc<AddItemFormEvent, AddItemFormState> {
  final UserRepository userRepository;
  final ItemRepository itemRepository;

  AddItemFormBloc({
    @required this.itemRepository,
    @required this.userRepository,
  })  : assert(itemRepository != null && userRepository != null),
        super(AddItemFormState.initial());

  @override
  Stream<Transition<AddItemFormEvent, AddItemFormState>> transformEvents(
    Stream<AddItemFormEvent> events,
    TransitionFunction<AddItemFormEvent, AddItemFormState> transFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! ItemQrChanged);
    });
    final debounceStream = events.where((event) {
      return (event is ItemQrChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transFn,
    );
  }

  @override
  Stream<AddItemFormState> mapEventToState(AddItemFormEvent event) async* {
    if (event is ItemQrChanged) {
      yield* _mapItemQrChangedToState(event.qr);
    } else if (event is ItemAmountChanged) {
      yield* _mapItemAmountChangedToState(event.amount);
    } else if (event is ItemQrSearch) {
      yield* _mapItemQrFetchedToState(event);
    } else if (event is ItemChange) {
      yield* _mapItemChangeToState();
    } else if (event is ItemAdd) {
      yield* _mapItemAddToState(event);
    } else if (event is AddItemFormReset) {
      yield* _mapAddItemFormResetToState();
    }
  }

  Stream<AddItemFormState> _mapItemQrFetchedToState(ItemQrSearch event) async* {
    yield state.searchLoading();
    try {
      final itemInfo = await itemRepository.getItem(
          event.qr, await userRepository.getToken());
      yield state.searchSuccess(itemInfo);
    } catch (error) {
      yield state.searchFailure(error.message);
    }
  }

  Stream<AddItemFormState> _mapItemQrChangedToState(String qr) async* {
    final isEntered = (qr != null && qr.isNotEmpty);
    if (!isEntered) {
      yield state.update(
        isItemIdEntered: false,
      );
      return;
    }
    yield state.update(
      isItemIdEntered: true,
    );
  }

  Stream<AddItemFormState> _mapItemAmountChangedToState(
      String amountText) async* {
    if (amountText == null || amountText.isEmpty) {
      yield state.update(
        isItemAmountEntered: false,
      );
      return;
    }
    var amount = int.tryParse(amountText);
    if (amount == null) {
      yield state.update(
        isItemAmountEntered: true,
        isItemAmountNumber: false,
      );
      return;
    }

    if (amount > 999) {
      yield state.update(
        isItemAmountEntered: true,
        isItemAmountNumber: true,
        isItemAmountAtLeastOne: true,
        isItemAmountLimitReached: true,
      );
      return;
    }

    if (amount < 1) {
      yield state.update(
        isItemAmountEntered: true,
        isItemAmountNumber: true,
        isItemAmountAtLeastOne: false,
        isItemAmountLimitReached: false,
      );
      return;
    }

    yield state.update(
      isItemAmountEntered: true,
      isItemAmountNumber: true,
      isItemAmountAtLeastOne: true,
      isItemAmountLimitReached: false,
    );
  }

  Stream<AddItemFormState> _mapItemChangeToState() async* {
    yield state.changeItem();
  }

  Stream<AddItemFormState> _mapItemAddToState(ItemAdd event) async* {
    final qrCode = state.item.qrCode;
    final amount = int.tryParse(event.amount);
    final storageType = event.storageType;
    yield state.adding();
    try {
      await itemRepository.addItem(
          qr: qrCode,
          storageType: storageType,
          amount: amount,
          token: await userRepository.getToken());
      yield state.addSuccess();
    } catch (error) {
      yield state.addFail();
    }
  }

  Stream<AddItemFormState> _mapAddItemFormResetToState() async* {
    yield AddItemFormState.initial();
  }
}
