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
    if (!_userRepository.isInit) {
      //TODO: If user is not init, fail and make it possible to retry in ui and create such retry-event
      yield SocketFailure();
      return;
    }

    final user = _userRepository.foodloadUser; //TODO: Prob create a getter
    _socketService.createSocketConnection(user.token);
    //TODO: Implement on connect in socket service with a callback here to set SocketSuccess!
    //This will work for now but is actually false...
    yield SocketSuccess();
  }

  Stream<SocketState> _mapSocketClosingToState() async* {
    _socketService.dispose();
    yield SocketFailure();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _socketService.dispose();
    return super.close();
  }
}
