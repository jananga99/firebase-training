part of 'sign_in_page_bloc.dart';

abstract class SignInPageEvent {}

class InitializeUserCheckEvent extends SignInPageEvent {}

class StartSignInEvent extends SignInPageEvent {
  final String email;
  final String password;
  StartSignInEvent({required this.email, required this.password});
}

class AuthorizeEvent extends SignInPageEvent {
  final User user;
  AuthorizeEvent(this.user);
}

class UnauthorizeEvent extends SignInPageEvent {}

class ErrorSignInEvent extends SignInPageEvent {
  final String error;
  ErrorSignInEvent({this.error = Messages.signInFailed});
}

class StartSignOutEvent extends SignInPageEvent {}

class SignOutEvent extends SignInPageEvent {}

class ErrorSignOutEvent extends SignInPageEvent {
  final String error;
  ErrorSignOutEvent({this.error = Messages.signOutFailed});
}
