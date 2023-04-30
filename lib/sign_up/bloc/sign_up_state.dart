part of 'sign_up_bloc.dart';

enum SignUpStatus {
  initial,
  emailChecking,
  emailCheckFailure,
  emailChecked,
  signUpLoading,
  signUpSucceeded,
  signUpFailure
}

class SignUpState extends Equatable {
  const SignUpState(
      {this.status = SignUpStatus.initial,
      this.email,
      this.password,
      this.emailCheckError,
      this.signUpError});

  final SignUpStatus status;
  final String? email;
  final String? password;
  final String? emailCheckError;
  final String? signUpError;

  SignUpState copyWith(
      {SignUpStatus? status,
      String? email,
      String? password,
      String? emailCheckError,
      String? signUpError}) {
    return SignUpState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        emailCheckError: emailCheckError ?? this.emailCheckError,
        signUpError: signUpError ?? this.signUpError);
  }

  @override
  List<dynamic> get props =>
      [status, email, password, emailCheckError, signUpError];
}
