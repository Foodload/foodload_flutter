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
      return (event is! ItemIdChanged);
    });
    final debounceStream = events.where((event) {
      return (event is ItemIdChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transFn,
    );
  }

  @override
  Stream<AddItemFormState> mapEventToState(AddItemFormEvent event) async* {
    if (event is ItemIdChanged) {
      yield* _mapItemIdChangedToState(event.id);
    } else if (event is ItemAmountChanged) {
      yield* _mapItemAmountChangedToState(event.amount);
    } else if (event is ItemIdSearch) {
      yield* _mapItemIdFetchedToState(event);
    } else if (event is ItemChange) {
      yield* _mapItemChangeToState();
    }
  }

  Stream<AddItemFormState> _mapItemIdFetchedToState(ItemIdSearch event) async* {
    yield state.searchLoading();
    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); //simulate api call or debounce here
    final itemInfo = await itemRepository.getItem(event.id);
    if (itemInfo == null) {
      yield state.searchFailure();
      return;
    }
    yield state.searchSuccess(itemInfo);
  }

  Stream<AddItemFormState> _mapItemIdChangedToState(String id) async* {
    final isEntered = (id != null && id.isNotEmpty);
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
        isItemAmountNumber: true,
        isItemAmountAtLeastOne: true,
        isItemAmountLimitReached: true,
      );
      return;
    }

    if (amount < 1) {
      yield state.update(
        isItemAmountNumber: true,
        isItemAmountAtLeastOne: false,
        isItemAmountLimitReached: false,
      );
      return;
    }

    yield state.update(
      isItemAmountNumber: true,
      isItemAmountAtLeastOne: true,
      isItemAmountLimitReached: false,
    );
  }

  Stream<AddItemFormState> _mapItemChangeToState() async* {
    yield state.update(
      isItemValid: false,
      isItemIdEntered: false,
    );
  }
}
