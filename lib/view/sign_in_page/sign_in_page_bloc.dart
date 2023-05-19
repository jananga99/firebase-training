import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/db/repo/user_repository.dart';
import 'package:project1/widgets/custom/constants.dart';

part 'sign_in_page_event.dart';
part 'sign_in_page_state.dart';

class SignInPageBloc extends Bloc<SignInPageEvent, SignInPageState> {
  SignInPageBloc() : super(SignInPageState.initialState) {
    on<InitializeUserCheckEvent>(_onInitializeUserCheck);
    on<StartSignInEvent>(_onStartSignIn);
    on<AuthorizeEvent>(_onAuthorize);
    on<UnauthorizeEvent>(_onUnauthorize);
    on<ErrorSignInEvent>(_onErrorSignIn);
    on<StartSignOutEvent>(_onStartSignOut);
    on<SignOutEvent>(_onSignOut);
    on<ErrorSignOutEvent>(_onErrorSignOut);
  }

  final UserRepository _userRepository = UserRepository();
  StreamSubscription<User?>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void _onInitializeUserCheck(
      InitializeUserCheckEvent event, Emitter<SignInPageState> emit) {
    _userSubscription?.cancel();
    _userSubscription = _userRepository.getUserStream().listen((user) {
      if (user == null) {
        add(UnauthorizeEvent());
      } else {
        add(AuthorizeEvent(user));
      }
    });
  }

  Future<void> _onStartSignIn(
      StartSignInEvent event, Emitter<SignInPageState> emit) async {
    emit(state.clone(status: SignInStatus.loading, error: null));
    try {
      final User? user =
          await _userRepository.signIn(event.email, event.password);
      add(AuthorizeEvent((user!)));
    } on FirebaseAuthException catch (e) {
      late String errorMessage;
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-email') {
        errorMessage = Messages.signInFailedInvalidEmailPassword;
      } else {
        errorMessage = Messages.signInFailed;
      }
      add(ErrorSignInEvent(error: errorMessage));
    } catch (e) {
      return add(ErrorSignInEvent());
    }
  }

  void _onAuthorize(AuthorizeEvent event, Emitter<SignInPageState> emit) {
    emit(state.clone(
        status: SignInStatus.authorized,
        user: event.user,
        email: null,
        password: null));
  }

  void _onUnauthorize(UnauthorizeEvent event, Emitter<SignInPageState> emit) {
    emit(state.clone(
        status: SignInStatus.unauthorized,
        user: null,
        email: null,
        password: null));
  }

  void _onErrorSignIn(ErrorSignInEvent event, Emitter<SignInPageState> emit) {
    emit(state.clone(status: SignInStatus.failure, error: event.error));
  }

  Future<void> _onStartSignOut(
      StartSignOutEvent event, Emitter<SignInPageState> emit) async {
    try {
      add(SignOutEvent());
    } catch (e) {
      add(ErrorSignOutEvent());
    }
  }

  void _onSignOut(SignOutEvent event, Emitter<SignInPageState> emit) {
    emit(SignInPageState.initialState);
  }

  void _onErrorSignOut(
      ErrorSignOutEvent event, Emitter<SignInPageState> emit) {}
}
