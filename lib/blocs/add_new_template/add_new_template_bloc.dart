import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/repositories/template_repository.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:foodload_flutter/models/exceptions/api_exception.dart';
import 'package:foodload_flutter/models/template.dart';
import 'package:meta/meta.dart';

import 'add_new_template.dart';

class AddNewTemplateBloc
    extends Bloc<AddNewTemplateEvent, AddNewTemplateState> {
  final TemplateRepository _templateRepository;
  final UserRepository _userRepository;

  AddNewTemplateBloc({
    @required templatesRepository,
    @required userRepository,
  })  : assert(
          templatesRepository != null && userRepository != null,
        ),
        _templateRepository = templatesRepository,
        _userRepository = userRepository,
        super(AddNewTemplateInit());

  @override
  Stream<AddNewTemplateState> mapEventToState(
      AddNewTemplateEvent event) async* {
    if (event is AddNewTemplate) {
      yield* _mapAddNewTemplateToState(event);
    }
  }

  Stream<AddNewTemplateState> _mapAddNewTemplateToState(
      AddNewTemplate event) async* {
    yield AddNewTemplateAdding();
    try {
      Template newTemplate = await _templateRepository.createTemplate(
          token: await _userRepository.getToken(), name: event.name);
      yield AddNewTemplateSuccess(newTemplate);
    } on ApiException catch (apiException) {
      yield AddNewTemplateFail(
          apiException.getMessage() ?? apiException.getPrefix());
    } catch (error, stackTrace) {
      ErrorHandler.reportCheckedError(
          SilentLogException(error.message), stackTrace);
      yield AddNewTemplateFail('Something went wrong. Please try again.');
    }
  }
}
