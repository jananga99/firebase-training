part of 'sign_in_page_bloc.dart';

enum SignInStatus { initial, loading, authorized, unauthorized, failure }

class SignInPageState {
  const SignInPageState(
      {required this.status,
      required this.email,
      required this.password,
      required this.error,
      required this.user});

  final SignInStatus status;
  final String? email;
  final String? password;
  final String? error;
  final User? user;

  static SignInPageState get initialState => const SignInPageState(
      status: SignInStatus.initial,
      email: null,
      password: null,
      error: null,
      user: null);

  SignInPageState clone(
      {SignInStatus? status,
      String? email,
      String? password,
      String? error,
      User? user}) {
    return SignInPageState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        error: error ?? this.error,
        user: user ?? this.user);
  }
}
