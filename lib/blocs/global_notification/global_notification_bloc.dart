import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodload_flutter/data/services/global_notification_service.dart';
import 'package:intl/intl.dart';

import 'global_notification_event.dart';
import 'global_notification_state.dart';

class GlobalNotificationBloc
    extends Bloc<GlobalNotificationEvent, GlobalNotificationState> {
  StreamSubscription _notificationSubscription;

  GlobalNotificationBloc() : super(GlobalNotificationState());

  @override
  Stream<GlobalNotificationState> mapEventToState(
      GlobalNotificationEvent event) async* {
    if (event is GlobalNotificationStart) {
      _notificationSubscription?.cancel();
      GlobalNotificationService globalNotificationService =
          GlobalNotificationService();
      _notificationSubscription = globalNotificationService.messageStream
          .listen((message) => {add(GlobalNotification(message: message))});
      yield GlobalNotificationSuccessful();
    } else if (event is GlobalNotification) {
      yield GlobalNotificationUpdated(
        title: 'New message',
        message: event.message,
        time: DateFormat.Hms().format(DateTime.now()),
      );
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
