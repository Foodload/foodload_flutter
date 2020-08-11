import 'package:equatable/equatable.dart';

abstract class SocketState extends Equatable {
  const SocketState();

  @override
  List<Object> get props => [];
}

class SocketSuccess extends SocketState {}

class SocketFailure extends SocketState {}

class SocketLoading extends SocketState {}
