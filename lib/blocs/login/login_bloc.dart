import 'dart:async';
import 'package:bloc/bloc.dart';
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
      //yield LoginState.loading();
      await _userRepository.signInWithGoogle();
      yield LoginState.success();
    } on NoSuchMethodError catch (_) {} catch (error) {
      yield LoginState.failure();
    }
  }
}
