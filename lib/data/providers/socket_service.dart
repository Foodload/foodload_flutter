import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:foodload_flutter/helpers/keys.dart';

class SocketService {
  IO.Socket _socket;
  static const UPDATE_ITEM = 'update_item';
  static const MOVE_ITEM = 'move_item';
  static const DELETE_ITEM = 'delete_item';

  void createSocketConnection(String token) {
    print("connecting to socket");
    _socket = IO.io(socketURL, <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
      'query': {'token': token},
    });

    _socket.on('connect', (_) {
      print('connect');
    });

    _socket.on('error', (data) {
      print('error');
      print(data);
    });

    _socket.on('connect_error', (_) {
      print('connect error...');
    });

    _socket.on('connecting', (_) {
      print('connecting');
    });

    _socket.on('connect_timeout', (_) {
      print('connect_timeout...');
    });

    _socket.on('reconnect_error', (_) {
      print('reconnect error...');
    });

    _socket.on('reconnect', (data) => print('reconnect'));

    _socket.on('reconnect_failed', (_) {
      print('reconnect failed...');
    });

    _socket.on('reconnect_attempt', (_) {
      print('reconnect_attempt...');
    });

    _socket.on('reconnecting', (_) {
      print('reconnecting...');
    });

    _socket.on('disconnect', (_) {
      print('disconnect');
    });
  }

  IO.Socket get socket {
    return _socket;
  }

  void dispose() {
    if (_socket != null) {
      print('disposing socket');
      _socket.dispose();
    }
  }
}
