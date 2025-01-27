import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/models/exceptions/api_exception.dart';
import 'package:meta/meta.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthStarted) {
      yield* _mapAuthStartedToState();
    } else if (event is AuthLoggedIn) {
      yield* _mapAuthLoggedInToState();
    } else if (event is AuthLoggedOut) {
      yield* _mapAuthLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAuthStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        await _userRepository.initUser();
        yield AuthSuccess(user.displayName);
      } else {
        yield AuthFailure();
      }
    } on ApiException catch (error) {
      //TODO: Log
      yield AuthFailure();
    } catch (error) {
      //TODO: Log
      yield AuthFailure();
    }
  }

  Stream<AuthState> _mapAuthLoggedInToState() async* {
    try {
      final user = await _userRepository.getUser();
      await _userRepository.initUser();
      yield AuthSuccess(user.displayName);
    } on ApiException catch (error) {
      //TODO: Log
      yield AuthFailure();
    } catch (error) {
      yield AuthFailure();
      //TODO: Log
    }
  }

  Stream<AuthState> _mapAuthLoggedOutToState() async* {
    yield AuthFailure();
    _userRepository.signOut();
  }
}
