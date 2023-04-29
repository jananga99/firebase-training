part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
  @override
  List<Object> get props => [];
}

class SignInInitialized extends SignInEvent {}

class SignInStarted extends SignInEvent {
  final String email;
  final String password;
  const SignInStarted({required this.email, required this.password});
}

class SignInSucceeded extends SignInEvent {
  final User user;
  const SignInSucceeded(this.user);
}

class SignInFailed extends SignInEvent {
  final String error;
  const SignInFailed({this.error = Messages.signInFailed});
}
