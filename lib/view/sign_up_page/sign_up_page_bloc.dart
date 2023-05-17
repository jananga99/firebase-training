import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/db/repo/user_repository.dart';

part 'sign_up_page_event.dart';
part 'sign_up_page_state.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvent, SignUpPageState> {
  final UserRepository _userRepository = UserRepository();

  SignUpPageBloc() : super(SignUpPageState.initialState) {
    on<CheckEmailEvent>(_onEmailCheckStarted);
    on<SuccessEmailCheckEvent>(_onEmailCheckSucceeded);
    on<ErrorEmailCheckEvent>(_onEmailCheckFailed);
    on<SignUpEvent>(_onSignUpStarted);
    on<SuccessSignUpEvent>(_onSignUpSucceeded);
    on<SignUpFailedEvent>(_onSignUpFailed);
    on<ResetSignUpEvent>(_onSignUpReset);
    on<ResetSignUpEmailEvent>(_onEmailReset);
    on<ResetPasswordEmailEvent>(_onPasswordReset);
  }

  Future<void> _onEmailCheckStarted(
      CheckEmailEvent event, Emitter<SignUpPageState> emit) async {
    emit(state.clone(
        status: SignUpStatus.emailChecking, password: null, signUpError: null));
    try {
      final bool isRegistered =
          await _userRepository.isEmailAlreadyRegistered(event.email);
      if (!isRegistered) {
        add(SuccessEmailCheckEvent(event.email));
      } else {
        add(ErrorEmailCheckEvent(error: Messages.signUpFailedDuplicateEmail));
      }
    } catch (e) {
      add(ErrorEmailCheckEvent(error: Messages.emailCheckFailed));
    }
  }

  void _onEmailCheckSucceeded(
      SuccessEmailCheckEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.emailChecked,
        email: event.email,
        emailCheckError: null));
  }

  void _onEmailCheckFailed(
      ErrorEmailCheckEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.emailCheckFailure,
        emailCheckError: event.error,
        email: null));
  }

  Future<void> _onSignUpStarted(
      SignUpEvent event, Emitter<SignUpPageState> emit) async {
    emit(state.clone(status: SignUpStatus.signUpLoading));
    if (state.email != null) {
      late String errorMessage;
      try {
        final UserCredential userCredential =
            await _userRepository.signUp(state.email!, event.password);
        if (userCredential.user != null) {
          return add(SuccessSignUpEvent());
        } else {
          errorMessage = Messages.signUpFailed;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          errorMessage = Messages.signUpFailedWeakPassword;
        } else if (e.code == 'email-already-in-use') {
          errorMessage = Messages.signUpFailedDuplicateEmail;
        } else {
          errorMessage = Messages.signUpFailed;
        }
      } catch (e) {
        errorMessage = Messages.signUpFailed;
      }
      add(SignUpFailedEvent(error: errorMessage));
    } else {
      add(SignUpFailedEvent());
    }
  }

  void _onSignUpSucceeded(
      SuccessSignUpEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(status: SignUpStatus.signUpSucceeded));
  }

  void _onSignUpFailed(SignUpFailedEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.signUpFailure, signUpError: event.error));
  }

  void _onSignUpReset(ResetSignUpEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.initial,
        email: null,
        password: null,
        emailCheckError: null,
        signUpError: null));
  }

  void _onPasswordReset(
      ResetPasswordEmailEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.initial, password: null, signUpError: null));
  }

  void _onEmailReset(
      ResetSignUpEmailEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(status: SignUpStatus.initial, emailCheckError: null));
  }
}
