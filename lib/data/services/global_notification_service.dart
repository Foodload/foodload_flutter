import 'dart:async';

class GlobalNotificationService {
  static final GlobalNotificationService _globalNotificationService =
      GlobalNotificationService._internal();

  factory GlobalNotificationService() {
    return _globalNotificationService;
  }

  GlobalNotificationService._internal();

  final _messageController = StreamController<String>();

  Stream<String> get messageStream => _messageController.stream;

  void globalNotifyMessage(String message) {
    _updateMessageListeners(message);
  }

  void _updateMessageListeners(String message) {
    _messageController.sink.add(message);
  }
}
