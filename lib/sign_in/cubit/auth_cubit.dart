import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/constants.dart';
import '../../repositories/repositories.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._userRepository) : super(const AuthState());
  final UserRepository _userRepository;
  StreamSubscription<User?>? _userSubscription;
  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void startAuth() {
    _userSubscription = _userRepository.getUserStream().listen((user) {
      if (user == null) {
        unAuthorize();
      } else {
        authorize(user);
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final SignInResult result = await _userRepository.signIn(email, password);
      if (result.success) {
        return authorize(result.user!);
      } else {
        return failSignIn(result.error!);
      }
    } catch (e) {
      return failSignIn(null);
    }
  }

  void authorize(User user) {
    emit(state.copyWith(
        status: AuthStatus.authorized,
        user: user,
        email: null,
        password: null));
  }

  void unAuthorize() {
    emit(state.copyWith(
        status: AuthStatus.unauthorized,
        user: null,
        email: null,
        password: null));
  }

  void failSignIn(String? error) {
    emit(state.copyWith(
        status: AuthStatus.failure, error: error ?? Messages.signOutFailed));
  }

  Future<void> signOut() async {
    if (await _userRepository.signOut()) {
      successSignOut();
    } else {
      failSignOut();
    }
  }

  void successSignOut() {
    emit(const AuthState());
  }

  void failSignOut() {}
}
