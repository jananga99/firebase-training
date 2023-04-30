part of 'sign_in_bloc.dart';

enum SignInStatus { initial, loading, authorized, unauthorized, failure }

class SignInState extends Equatable {
  const SignInState(
      {this.status = SignInStatus.initial,
      this.email,
      this.password,
      this.error,
      this.user});

  final SignInStatus status;
  final String? email;
  final String? password;
  final String? error;
  final User? user;

  SignInState copyWith(
      {SignInStatus? status,
      String? email,
      String? password,
      String? error,
      User? user}) {
    return SignInState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        error: error ?? this.error,
        user: user ?? this.user);
  }

  @override
  List<dynamic> get props => [status, email, password];
}
