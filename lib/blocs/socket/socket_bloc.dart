import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/blocs/auth/auth_bloc.dart';
import 'package:foodload_flutter/blocs/socket/bloc.dart';
import 'package:foodload_flutter/data/providers/socket_service.dart';
import 'package:foodload_flutter/data/repositories/user_repository.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  final UserRepository _userRepository;
  final SocketService _socketService;
  final AuthBloc _authBloc;
  StreamSubscription _authSubscription;

  SocketBloc({
    @required UserRepository userRepository,
    @required SocketService socketService,
    @required AuthBloc authBloc,
  })  : assert(userRepository != null &&
            socketService != null &&
            authBloc != null),
        _userRepository = userRepository,
        _socketService = socketService,
        _authBloc = authBloc,
        super(SocketLoading()) {
    _authSubscription = _authBloc.listen((state) {
      if (state is AuthSuccess) {
        add(SocketStarted());
      }
      if (state is AuthFailure) {
        add(SocketClosing());
      }
    });
  }

  @override
  Stream<SocketState> mapEventToState(SocketEvent event) async* {
    if (event is SocketStarted) {
      yield* _mapSocketStartedToState();
    } else if (event is SocketClosing) {
      yield* _mapSocketClosingToState();
    }
  }

  Stream<SocketState> _mapSocketStartedToState() async* {
    final user = _userRepository.foodloadUser;
    _socketService.createSocketConnection(
        user.token, _onSocketSuccess, _onSocketFailure);
    //TODO: Test and change state somewhere else / other way
    yield SocketSuccess();
  }

  Stream<SocketState> _mapSocketClosingToState() async* {
    _socketService.dispose();
    yield SocketFailure();
  }

  void _onSocketSuccess() {
    print("Socket Bloc: ");
    print("Success");
  }

  void _onSocketFailure() {
    print("Socket Bloc: ");
    print("Fail");
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _socketService.dispose();
    return super.close();
  }
}
