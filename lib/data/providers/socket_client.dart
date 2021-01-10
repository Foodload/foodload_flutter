import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:foodload_flutter/helpers/keys.dart';

class SocketClient {
  IO.Socket _socket;
  static const UPDATE_ITEM = 'update_item';
  static const MOVE_ITEM = 'move_item';
  static const DELETE_ITEM = 'delete_item';

  void createSocketConnection(
      String token, Function onSocketSuccess, Function onSocketFailure) {
    print("connecting to socket");
    _socket = IO.io(socketURL, <String, dynamic>{
      'transports': ['websocket'],
      'forceNew': true,
      'query': {'token': token},
    });

    _socket.on('connect', (_) {
      print('SocketClient: connect');
      onSocketSuccess();
    });

    _socket.on('error', (data) {
      print('SocketClient: error');
      print(data);
    });

    _socket.on('connect_error', (_) {
      print('SocketClient: connect error...');
      onSocketFailure();
    });

    _socket.on('connecting', (_) {
      print('SocketClient: connecting');
    });

    _socket.on('connect_timeout', (_) {
      print('SocketClient: connect_timeout...');
    });

    _socket.on('reconnect_error', (_) {
      print('SocketClient: reconnect error...');
    });

    _socket.on('reconnect', (_) {
      print('SocketClient: reconnect');
    });

    _socket.on('reconnect_failed', (_) {
      print('SocketClient: reconnect failed...');
    });

    _socket.on('reconnect_attempt', (_) {
      print('SocketClient: reconnect_attempt...');
    });

    _socket.on('reconnecting', (_) {
      print('SocketClient: reconnecting...');
    });

    _socket.on('disconnect', (_) {
      print('SocketClient: disconnect');
    });
  }

  IO.Socket get socket => _socket;

  void dispose() {
    if (_socket != null) {
      print('SocketClient: disposing socket');
      _socket.dispose();
    }
  }
}
