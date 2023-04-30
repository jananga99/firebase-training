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

class Authorized extends SignInEvent {
  final User user;
  const Authorized(this.user);
}

class Unauthorized extends SignInEvent {
  const Unauthorized();
}

class SignInFailed extends SignInEvent {
  final String error;
  const SignInFailed({this.error = Messages.signInFailed});
}

class SignOutStarted extends SignInEvent {}

class SignOutSucceeded extends SignInEvent {}

class SignOutFailed extends SignInEvent {
  final String error;
  const SignOutFailed({this.error = Messages.signOutFailed});
}
