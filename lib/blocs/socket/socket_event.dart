import 'package:equatable/equatable.dart';

abstract class SocketEvent extends Equatable {
  const SocketEvent();

  @override
  List<Object> get props => [];
}

class SocketStarted extends SocketEvent {}
