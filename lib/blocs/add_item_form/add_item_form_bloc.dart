import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/item_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/field_validation.dart';
import 'package:foodload_flutter/models/enums/field_error.dart';
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
        super(AddItemFormState());

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
    yield state.copyWith(isSearching: true);
    try {
      final itemInfo = await itemRepository.getItem(
          event.qr, await userRepository.getToken());
      yield state.copyWith(
          isSearching: false, searchSuccess: true, item: itemInfo);
    } catch (error) {
      //TODO: Add error handling...
      yield state.copyWith(isSearching: false, searchSuccess: false);
    }
  }

  Stream<AddItemFormState> _mapItemQrChangedToState(String qr) async* {
    if (!FieldValidation.isNotEmpty(qr)) {
      yield state.copyWith(itemIdError: FieldError.Empty);
      return;
    }

    yield state.itemIdValid();
  }

  Stream<AddItemFormState> _mapItemAmountChangedToState(
      String amountText) async* {
    if (amountText == null || amountText.isEmpty) {
      yield state.copyWith(amountError: FieldError.Empty);
      return;
    }
    if (!FieldValidation.isInteger(amountText)) {
      yield state.copyWith(amountError: FieldError.Invalid);
      return;
    }
    final amount = int.parse(amountText);

    if (FieldValidation.isAmountOverflow(amount)) {
      yield state.copyWith(amountError: FieldError.AmountOverflow);
      return;
    }

    if (amount < 1) {
      yield state.copyWith(amountError: FieldError.NegativeAmount);
      return;
    }

    yield state.amountValid();
  }

  Stream<AddItemFormState> _mapItemChangeToState() async* {
    yield state.changeItem();
  }

  Stream<AddItemFormState> _mapItemAddToState(ItemAdd event) async* {
    final qrCode = state.item.qrCode;
    final amount = int.tryParse(event.amount);
    final storageType = event.storageType;
    yield state.copyWith(isAdding: true);
    try {
      await itemRepository.addItem(
          qr: qrCode,
          storageType: storageType,
          amount: amount,
          token: await userRepository.getToken());
      yield state.copyWith(addSuccess: true, isAdding: false);
    } catch (error) {
      yield state.copyWith(addSuccess: false, isAdding: false);
    }
  }

  Stream<AddItemFormState> _mapAddItemFormResetToState() async* {
    yield AddItemFormState();
  }
}
