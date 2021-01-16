import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/helpers/error_handler/core/error_handler.dart';
import 'package:foodload_flutter/helpers/error_handler/model/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:foodload_flutter/blocs/login/bloc.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    try {
      yield LoginState.loading();
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } on NoSuchMethodError catch (_) {
      yield LoginState.initial(); //aborted, restart
    } catch (error, stackTrace) {
      ErrorHandler.reportCheckedError(
          SilentLogException(error.message), stackTrace);
      yield LoginState.failure();
    }
  }
}
