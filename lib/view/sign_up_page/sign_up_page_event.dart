part of 'sign_up_page_bloc.dart';

abstract class SignUpPageEvent {}

class CheckEmailEvent extends SignUpPageEvent {
  final String email;
  CheckEmailEvent(this.email);
}

class SuccessEmailCheckEvent extends SignUpPageEvent {
  final String email;
  SuccessEmailCheckEvent(this.email);
}

class ErrorEmailCheckEvent extends SignUpPageEvent {
  final String? error;
  ErrorEmailCheckEvent({this.error = Messages.emailCheckFailed});
}

class SignUpEvent extends SignUpPageEvent {
  final String password;
  SignUpEvent(this.password);
}

class SuccessSignUpEvent extends SignUpPageEvent {}

class SignUpFailedEvent extends SignUpPageEvent {
  final String? error;
  SignUpFailedEvent({this.error = Messages.signUpFailed});
}

class ResetSignUpEvent extends SignUpPageEvent {}

class ResetSignUpEmailEvent extends SignUpPageEvent {}

class ResetPasswordEmailEvent extends SignUpPageEvent {}
