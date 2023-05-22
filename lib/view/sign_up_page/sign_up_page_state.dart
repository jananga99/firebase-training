part of 'sign_up_page_bloc.dart';

enum SignUpStatus {
  initial,
  emailChecking,
  emailCheckFailure,
  emailChecked,
  signUpLoading,
  signUpSucceeded,
  signUpFailure
}

class SignUpPageState {
  const SignUpPageState(
      {required this.status,
      required this.email,
      required this.password,
      required this.emailCheckError,
      required this.signUpError});

  final SignUpStatus status;
  final String? email;
  final String? password;
  final String? emailCheckError;
  final String? signUpError;

  static SignUpPageState get initialState => const SignUpPageState(
      status: SignUpStatus.initial,
      email: null,
      password: null,
      emailCheckError: null,
      signUpError: null);

  SignUpPageState clone(
      {SignUpStatus? status,
      String? email,
      String? password,
      String? emailCheckError,
      String? signUpError}) {
    return SignUpPageState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        emailCheckError: emailCheckError ?? this.emailCheckError,
        signUpError: signUpError ?? this.signUpError);
  }
}
