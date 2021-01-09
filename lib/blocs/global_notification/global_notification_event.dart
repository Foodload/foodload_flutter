import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class GlobalNotificationEvent extends Equatable {
  const GlobalNotificationEvent();

  @override
  List<Object> get props => [];
}

class GlobalNotificationStart extends GlobalNotificationEvent {
  @override
  String toString() => 'GlobalNotificationInit {}';
}

class GlobalNotification extends GlobalNotificationEvent {
  final String message;

  const GlobalNotification({@required this.message});

  @override
  String toString() => 'GlobalNotification { message: $message }';
}
