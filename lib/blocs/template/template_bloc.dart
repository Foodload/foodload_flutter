import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/template/template_event.dart';
import 'package:foodload_flutter/blocs/template/template_state.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/exceptions/api_exception.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:foodload_flutter/models/template_item.dart';
import 'package:meta/meta.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final UserRepository _userRepository;
  final TemplateRepository _templateRepository;

  TemplateBloc({
    @required templateId,
    @required templateRepository,
    @required userRepository,
  })  : assert(templateId != null &&
            templateRepository != null &&
            userRepository != null),
        _userRepository = userRepository,
        _templateRepository = templateRepository,
        super(TemplateStateLoading()) {
    add(FetchTemplate(templateId));
  }

  @override
  Stream<TemplateState> mapEventToState(TemplateEvent event) async* {
    if (event is FetchTemplate) {
      yield* _mapFetchTemplateToState(event);
    } else if (event is TemplateItemAdded) {
      yield* _mapTemplateItemAddedToState(event);
    } else if (event is DeleteTemplateItemFromState) {
      yield* _mapDeleteTemplateItemFromStateToState(event);
    } else if (event is DeleteTemplateItem) {
      yield* _mapDeleteTemplateItemToState(event);
    } else if (event is UndoDeleteTemplateItem) {
      yield* _mapUndoDeleteTemplateItemToState(event);
    } else if (event is UpdateTemplateItem) {
      yield* _mapUpdateTemplateItemToState(event);
    }
  }

  Stream<TemplateState> _mapFetchTemplateToState(FetchTemplate event) async* {
    try {
      final template = await _templateRepository.getTemplate(event.templateId);
      yield TemplateState(template: template);
    } on ApiException catch (apiException) {
      yield* _handleApiException(apiException);
    } catch (error, stackTrace) {
      yield* _handleError(error, stackTrace);
    }
  }

  Stream<TemplateState> _mapTemplateItemAddedToState(
      TemplateItemAdded event) async* {
    try {
      final updatedTemplate =
          await _templateRepository.getTemplate(state.template.id);
      yield TemplateState(template: updatedTemplate);
    } on ApiException catch (apiException) {
      yield* _handleApiException(apiException);
    } catch (error, stackTrace) {
      yield* _handleError(error, stackTrace);
    }
  }

  Stream<TemplateState> _mapDeleteTemplateItemFromStateToState(
      DeleteTemplateItemFromState event) async* {
    try {
      final List<TemplateItem> updatedTemplateItems = state
          .template.templateItems
          .where((templateItem) => templateItem.id != event.templateItemId)
          .toList();
      final Template updatedTemplate =
          state.template.copyWith(templateItems: updatedTemplateItems);
      yield state.copyWith(template: updatedTemplate);
    } catch (error, stackTrace) {
      yield* _handleError(error, stackTrace);
    }
  }

  Stream<TemplateState> _mapDeleteTemplateItemToState(
      DeleteTemplateItem event) async* {
    try {
      await _templateRepository.deleteTemplateItem(
          await _userRepository.getToken(),
          state.template.id,
          event.templateItemId);
    } on ApiException catch (apiException) {
      yield* _handleApiException(apiException);
    } catch (error, stackTrace) {
      yield* _handleError(error, stackTrace);
    }
  }

  Stream<TemplateState> _mapUndoDeleteTemplateItemToState(
      UndoDeleteTemplateItem event) async* {
    try {
      final Template prevTemplate =
          await _templateRepository.getTemplate(state.template.id);
      yield state.copyWith(template: prevTemplate);
    } on ApiException catch (apiException) {
      yield* _handleApiException(apiException);
    } catch (error, stackTrace) {
      yield* _handleError(error, stackTrace);
    }
  }

  Stream<TemplateState> _mapUpdateTemplateItemToState(
      UpdateTemplateItem event) async* {
    try {
      await _templateRepository.updateTemplateItem(
          token: await _userRepository.getToken(),
          templateId: state.template.id,
          templateItemId: event.templateItemId,
          newAmount: event.newAmount);
      final updatedTemplate =
          await _templateRepository.getTemplate(state.template.id);
      yield state.copyWith(template: updatedTemplate);
    } on ApiException catch (apiException) {
      yield* _handleApiException(apiException);
    } catch (error, stackTrace) {
      yield* _handleError(error, stackTrace);
    }
  }

  Stream<TemplateState> _handleApiException(ApiException apiException) async* {
    yield state.copyWith(
      status: Status.ERROR,
      errorMessage: apiException.getMessage() ?? apiException.getPrefix(),
    );
  }

  Stream<TemplateState> _handleError(error, stackTrace) async* {
    ErrorHandler.reportCheckedError(
        SilentLogException(error.message), stackTrace);
    yield state.copyWith(
        status: Status.ERROR,
        errorMessage: 'Something went wrong. Please try again later.');
  }
}
