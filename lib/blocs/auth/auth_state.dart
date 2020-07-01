part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final String displayName;

  const AuthSuccess(this.displayName);

  @override
  List<Object> get props => [displayName];

  @override
  String toString() => 'AuthSuccess { displayName: $displayName }';
}

class AuthFailure extends AuthState {}
