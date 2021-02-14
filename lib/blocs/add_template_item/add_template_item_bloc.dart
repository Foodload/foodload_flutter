import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/add_template_item/add_template_item.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/error_handler/model/status.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:meta/meta.dart';

class AddTemplateItemBloc
    extends Bloc<AddTemplateItemEvent, AddTemplateItemState> {
  final UserRepository _userRepository;
  final TemplateRepository _templateRepository;

  AddTemplateItemBloc({
    @required templateRepository,
    @required userRepository,
  })  : assert(templateRepository != null && userRepository != null),
        _userRepository = userRepository,
        _templateRepository = templateRepository,
        super(AddTemplateItemState());

  @override
  Stream<AddTemplateItemState> mapEventToState(
      AddTemplateItemEvent event) async* {
    if (event is ItemSelected) {
      yield* _mapItemSelectedToState(event);
    } else if (event is AddTemplateItem) {
      yield* _mapAddTemplateItemToState(event);
    } else if (event is ChangeItem) {
      yield* _mapChangeItemToState(event);
    } else if (event is ItemAmountChanged) {
      yield* _mapItemAmountChangedToState(event);
    }
  }

  Stream<AddTemplateItemState> _mapItemSelectedToState(
      ItemSelected event) async* {
    yield AddTemplateItemState(
      item: event.selectedItem,
      amount: event.initAmount,
      validAmount: true,
    );
  }

  Stream<AddTemplateItemState> _mapAddTemplateItemToState(
      AddTemplateItem event) async* {
    if (!state.isFormValid) {
      //TODO: Error...?
      return;
    }
    yield state.copyWith(addStatus: Status.LOADING);
    try {
      TemplateItem templateItem =
          await _templateRepository.addTemplateItemToTemplate(
        await _userRepository.getToken(),
        event.templateId,
        state.item.id,
        state.amount,
      );
      print(templateItem);
      yield AddTemplateItemSuccess(templateItem);
    } catch (error) {
      //TODO: Error handling
      print(error);
    }
  }

  Stream<AddTemplateItemState> _mapChangeItemToState(ChangeItem event) async* {
    yield AddTemplateItemState();
  }

  Stream<AddTemplateItemState> _mapItemAmountChangedToState(
      ItemAmountChanged event) async* {
    yield state.copyWith(amount: event.amount, validAmount: event.valid);
  }
}
