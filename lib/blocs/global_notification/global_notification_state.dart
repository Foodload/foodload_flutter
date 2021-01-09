import 'package:equatable/equatable.dart';

class GlobalNotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class GlobalNotificationInit extends GlobalNotificationState {}

class GlobalNotificationSuccessful extends GlobalNotificationState {}

class GlobalNotificationUpdated extends GlobalNotificationState {
  final String title;
  final String message;
  final String time;

  GlobalNotificationUpdated({
    this.title,
    this.message,
    this.time,
  });

  @override
  List<Object> get props => [
        title,
        message,
        time,
      ];

  @override
  String toString() {
    return 'GlobalNotificationUpdated { title: $title, message: $message, time: $time }';
  }
}
