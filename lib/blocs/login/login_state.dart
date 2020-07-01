import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isInitial;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  LoginState({
    @required this.isInitial,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory LoginState.initial() {
    return LoginState(
      isInitial: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isInitial: false,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isInitial: false,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isInitial: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isInitial: $isInitial,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
