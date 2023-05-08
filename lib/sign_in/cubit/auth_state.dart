part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authorized, unauthorized, failure }

class AuthState extends Equatable {
  const AuthState(
      {this.status = AuthStatus.initial,
      this.email,
      this.password,
      this.error,
      this.user});

  final AuthStatus status;
  final String? email;
  final String? password;
  final String? error;
  final User? user;

  AuthState copyWith(
      {AuthStatus? status,
      String? email,
      String? password,
      String? error,
      User? user}) {
    return AuthState(
        status: status ?? this.status,
        email: email ?? this.email,
        password: password ?? this.password,
        error: error ?? this.error,
        user: user ?? this.user);
  }

  @override
  List<dynamic> get props => [status, email, password];
}
