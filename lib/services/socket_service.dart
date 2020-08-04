import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:foodload_flutter/helpers/keys.dart';

class SocketService {
  IO.Socket _socket;

  void createSocketConnection(String token) {
    _socket = IO.io(socket_uri, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'token': token},
    });

    _socket.on('connect_error', (_) {
      print('connect error...');
    });
  }

  void setOnUpdateItem(Function onUpdateItem) {
    if (_socket == null) {
      print('Socket is null (setOnUpdateItem)');
      return;
    }
    _socket.on('update_item', (data) {
      print(data);
      Map<String, dynamic> decoded = jsonDecode(data);
      onUpdateItem(decoded);
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
      _socket.dispose();
    }
  }
}
