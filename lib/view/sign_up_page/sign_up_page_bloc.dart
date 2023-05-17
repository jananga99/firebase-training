import 'package:bloc/bloc.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/repositories/user_repository/models/sign_up_email_check.dart';
import 'package:project1/repositories/user_repository/models/sign_up_result.dart';
import 'package:project1/repositories/user_repository/user_repository.dart';

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
    final SignUpEmailCheckResult result =
        await _userRepository.isEmailAlreadyRegistered(event.email);
    if (result.success && result.isRegistered.runtimeType == bool) {
      if (!result.isRegistered!) {
        add(SuccessEmailCheckEvent(event.email));
      } else {
        add(ErrorEmailCheckEvent(error: Messages.signUpFailedDuplicateEmail));
      }
    } else {
      add(ErrorEmailCheckEvent(error: result.error));
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
      final SignUpResult result =
          await _userRepository.signUp(state.email!, event.password);
      if (result.success) {
        add(SuccessSignUpEvent());
      } else {
        add(SignUpFailedEvent(error: result.error));
      }
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
