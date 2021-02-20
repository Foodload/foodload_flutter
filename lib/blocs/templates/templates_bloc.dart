import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/templates/templates_event.dart';
import 'package:foodload_flutter/blocs/templates/templates_state.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:foodload_flutter/models/enums/status.dart';
import 'package:foodload_flutter/models/exceptions/api_exception.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:meta/meta.dart';

class TemplatesBloc extends Bloc<TemplatesEvent, TemplatesState> {
  final TemplateRepository _templateRepository;
  final UserRepository _userRepository;

  TemplatesBloc({
    @required templatesRepository,
    @required userRepository,
  })  : assert(
          templatesRepository != null && userRepository != null,
        ),
        _templateRepository = templatesRepository,
        _userRepository = userRepository,
        super(TemplatesState(templatesStatus: Status.LOADING));

  @override
  Stream<TemplatesState> mapEventToState(TemplatesEvent event) async* {
    if (event is FetchTemplates) {
      yield* _mapFetchTemplatesToState();
    } else if (event is RefreshTemplates) {
      yield* _mapRefreshTemplatesToState();
    } else if (event is DeleteTemplate) {
      yield* _mapDeleteTemplateToState(event);
    } else if (event is DeleteTemplateFromList) {
      yield* _mapDeleteTemplateFromListToState(event);
    } else if (event is UndoDeleteTemplate) {
      yield* _mapUndoDeleteTemplate(event);
    } else if (event is AddNewTemplateToList) {
      yield* _mapAddNewTemplateToListToState(event);
    }
  }

  Stream<TemplatesState> _mapAddNewTemplateToListToState(
      AddNewTemplateToList event) async* {
    try {
      List<Template> templates = state.templates.toList();
      templates.add(event.newTemplate);
      yield state.copyWith(templates: templates);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  Stream<TemplatesState> _mapRefreshTemplatesToState() async* {
    yield state.copyWith(templatesStatus: Status.REFRESHING);
    try {
      List<Template> templates = await _templateRepository.getTemplates(
          token: await _userRepository.getToken(), refresh: true);
      yield state.copyWith(
          templatesStatus: Status.COMPLETED, templates: templates);
    } on ApiException catch (apiException) {
      yield state.copyWith(
        templatesStatus: Status.ERROR,
        templatesErrorMessage:
            apiException.getMessage() ?? apiException.getPrefix(),
        templates: await _templateRepository.getTemplates(),
      );
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  Stream<TemplatesState> _mapFetchTemplatesToState() async* {
    try {
      List<Template> templates = await _templateRepository.getTemplates();
      if (templates == null) {
        templates = await _templateRepository.getTemplates(
            token: await _userRepository.getToken(), refresh: true);
      }
      yield TemplatesState(
          templatesStatus: Status.COMPLETED, templates: templates);
    } on ApiException catch (apiException) {
      yield state.copyWith(
        templatesStatus: Status.ERROR,
        templatesErrorMessage:
            apiException.getMessage() ?? apiException.getPrefix(),
      );
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  Stream<TemplatesState> _mapDeleteTemplateToState(
      DeleteTemplate event) async* {
    try {
      await _templateRepository.deleteTemplate(
          await _userRepository.getToken(), event.templateId);
    } on ApiException catch (apiException) {
      yield state.copyWith(
        templatesStatus: Status.ERROR,
        templatesErrorMessage:
            apiException.getMessage() ?? apiException.getPrefix(),
        templates: await _templateRepository.getTemplates(),
      );
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  Stream<TemplatesState> _mapDeleteTemplateFromListToState(
      DeleteTemplateFromList event) async* {
    try {
      final List<Template> updatedTemplates = state.templates
          .where((template) => template.id != event.templateId)
          .toList();
      yield state.copyWith(
          templatesStatus: Status.COMPLETED, templates: updatedTemplates);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  Stream<TemplatesState> _mapUndoDeleteTemplate(
      UndoDeleteTemplate event) async* {
    try {
      final List<Template> prevTemplates =
          await _templateRepository.getTemplates();
      yield state.copyWith(templates: prevTemplates);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  Stream<TemplatesState> _handleError(error, stackTrace) async* {
    ErrorHandler.reportCheckedError(
        SilentLogException(error.message), stackTrace);
    yield TemplatesState(templatesStatus: Status.ERROR);
  }
}
