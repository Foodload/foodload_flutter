import 'dart:convert';

import 'package:foodload_flutter/models/item.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:foodload_flutter/helpers/keys.dart';

class SocketService {
  IO.Socket _socket;

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

  void setOnUpdateItem(Function onUpdateItem) {
    if (_socket == null) {
      print('Socket is null (setOnUpdateItem)');
      return;
    }

    if (onUpdateItem == null) {
      _socket.off('update_item');
      return;
    }

    _socket.on('update_item', (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      print(decoded);
      final item = Item.fromJson(decoded);
      //onUpdateItem(item);
    });
  }

  void setOnMoveItem(Function onMoveItem) {
    if (_socket == null) {
      print('Socket is null (setOnMoveItem)');
      return;
    }

    if (onMoveItem == null) {
      _socket.off('move_item');
      return;
    }

    _socket.on('move_item', (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      final srcItem = Item.fromItemCountJson(decoded['srcItemCount']);
      final destItem = Item.fromItemCountJson(decoded['destItemCount']);
      onMoveItem([srcItem, destItem]);
    });
  }

  void setOnFamilyInvite(Function onFamilyInvite) {
    if (_socket == null) {
      print('Socket is null (setOnFamilyInvite)');
      return;
    }
    _socket.on('family_invite', (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      onFamilyInvite(decoded);
    });
  }

  void setOnChangedFamily(Function onChangedFamily) {
    if (_socket == null) {
      print('Socket is null (setOnChangedFamily)');
      return;
    }
    _socket.on('changed_family', (data) {
      Map<String, dynamic> decoded = jsonDecode(data);
      onChangedFamily(decoded);
    });
  }

  void dispose() {
    if (_socket != null) {
      print('disposing socket');
      _socket.dispose();
    }
  }
}
