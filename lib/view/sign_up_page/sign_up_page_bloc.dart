import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/db/repo/user_repository.dart';

part 'sign_up_page_event.dart';
part 'sign_up_page_state.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvent, SignUpPageState> {
  final UserRepository _userRepository = UserRepository();

  SignUpPageBloc() : super(SignUpPageState.initialState) {
    on<CheckEmailEvent>(_onCheckEmail);
    on<SuccessEmailCheckEvent>(_onSuccessEmailCheck);
    on<ErrorEmailCheckEvent>(_onErrorEmailCheck);
    on<SignUpEvent>(_onSignUp);
    on<SuccessSignUpEvent>(_onSuccessSignUp);
    on<ErrorSignUpEvent>(_onErrorSignUp);
    on<ResetSignUpEvent>(_onResetSignUp);
    on<ResetSignUpEmailEvent>(_onResetSignUpEmail);
    on<ResetPasswordEmailEvent>(_onResetPasswordEmail);
  }

  Future<void> _onCheckEmail(
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

  void _onSuccessEmailCheck(
      SuccessEmailCheckEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.emailChecked,
        email: event.email,
        emailCheckError: null));
  }

  void _onErrorEmailCheck(
      ErrorEmailCheckEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.emailCheckFailure,
        emailCheckError: event.error,
        email: null));
  }

  Future<void> _onSignUp(
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
      add(ErrorSignUpEvent(error: errorMessage));
    } else {
      add(ErrorSignUpEvent());
    }
  }

  void _onSuccessSignUp(
      SuccessSignUpEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(status: SignUpStatus.signUpSucceeded));
  }

  void _onErrorSignUp(ErrorSignUpEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.signUpFailure, signUpError: event.error));
  }

  void _onResetSignUp(ResetSignUpEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.initial,
        email: null,
        password: null,
        emailCheckError: null,
        signUpError: null));
  }

  void _onResetPasswordEmail(
      ResetPasswordEmailEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(
        status: SignUpStatus.initial, password: null, signUpError: null));
  }

  void _onResetSignUpEmail(
      ResetSignUpEmailEvent event, Emitter<SignUpPageState> emit) {
    emit(state.clone(status: SignUpStatus.initial, emailCheckError: null));
  }
}
