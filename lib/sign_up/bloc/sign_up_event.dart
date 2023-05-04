part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailCheckStarted extends SignUpEvent {
  final String email;
  EmailCheckStarted(this.email);
}

class EmailCheckSucceeded extends SignUpEvent {
  final String email;
  EmailCheckSucceeded(this.email);
}

class EmailCheckFailed extends SignUpEvent {
  final String? error;
  EmailCheckFailed({this.error = Messages.emailCheckFailed});
}

class SignUpStarted extends SignUpEvent {
  final String password;
  SignUpStarted(this.password);
}

class SignUpSucceeded extends SignUpEvent {}

class SignUpFailed extends SignUpEvent {
  final String? error;
  SignUpFailed({this.error = Messages.signUpFailed});
}

class SignUpReset extends SignUpEvent {}

class EmailReset extends SignUpEvent {}

class PasswordReset extends SignUpEvent {}
