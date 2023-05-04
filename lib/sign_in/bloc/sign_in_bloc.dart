import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/constants.dart';
import '../../repositories/user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc(this._userRepository) : super(const SignInState()) {
    on<SignInInitialized>(_onSignInInitialized);
    on<SignInStarted>(_onSignInStarted);
    on<Authorized>(_onAuthorized);
    on<Unauthorized>(_onUnauthorized);
    on<SignInFailed>(_onSignInFailed);
    on<SignOutStarted>(_onSignOutStarted);
    on<SignOutSucceeded>(_onSignOutSucceeded);
    on<SignOutFailed>(_onSignOutFailed);
  }

  final UserRepository _userRepository;
  StreamSubscription<User?>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void _onSignInInitialized(
      SignInInitialized event, Emitter<SignInState> emit) {
    _userSubscription = _userRepository.getUserStream().listen((user) {
      if (user == null) {
        add(const Unauthorized());
      } else {
        add(Authorized(user));
      }
    });
  }

  Future<void> _onSignInStarted(
      SignInStarted event, Emitter<SignInState> emit) async {
    emit(state.copyWith(status: SignInStatus.loading, error: null));
    try {
      final SignInResult result =
          await _userRepository.signIn(event.email, event.password);
      if (result.success) {
        return add(Authorized(result.user!));
      } else {
        return add(SignInFailed(error: result.error!));
      }
    } catch (e) {
      return add(const SignInFailed());
    }
  }

  void _onAuthorized(Authorized event, Emitter<SignInState> emit) {
    emit(state.copyWith(
        status: SignInStatus.authorized,
        user: event.user,
        email: null,
        password: null));
  }

  void _onUnauthorized(Unauthorized event, Emitter<SignInState> emit) {
    emit(state.copyWith(
        status: SignInStatus.unauthorized,
        user: null,
        email: null,
        password: null));
  }

  void _onSignInFailed(SignInFailed event, Emitter<SignInState> emit) {
    emit(state.copyWith(status: SignInStatus.failure, error: event.error));
  }

  Future<void> _onSignOutStarted(
      SignOutStarted event, Emitter<SignInState> emit) async {
    if (await _userRepository.signOut()) {
      add(SignOutSucceeded());
    } else {
      add(const SignOutFailed());
    }
  }

  void _onSignOutSucceeded(SignOutSucceeded event, Emitter<SignInState> emit) {
    emit(const SignInState());
  }

  void _onSignOutFailed(SignOutFailed event, Emitter<SignInState> emit) {}
}
