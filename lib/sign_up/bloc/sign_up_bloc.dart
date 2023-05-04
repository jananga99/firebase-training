import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/repositories/user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(const SignUpState()) {
    on<EmailCheckStarted>(_onEmailCheckStarted);
    on<EmailCheckSucceeded>(_onEmailCheckSucceeded);
    on<EmailCheckFailed>(_onEmailCheckFailed);
    on<SignUpStarted>(_onSignUpStarted);
    on<SignUpSucceeded>(_onSignUpSucceeded);
    on<SignUpFailed>(_onSignUpFailed);
    on<SignUpReset>(_onSignUpReset);
    on<EmailReset>(_onEmailReset);
    on<PasswordReset>(_onPasswordReset);
  }

  Future<void> _onEmailCheckStarted(
      EmailCheckStarted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(
        status: SignUpStatus.emailChecking, password: null, signUpError: null));
    final SignUpEmailCheckResult result =
        await _userRepository.isEmailAlreadyRegistered(event.email);
    if (result.success && result.isRegistered.runtimeType == bool) {
      if (!result.isRegistered!) {
        add(EmailCheckSucceeded(event.email));
      } else {
        add(EmailCheckFailed(error: Messages.signUpFailedDuplicateEmail));
      }
    } else {
      add(EmailCheckFailed(error: result.error));
    }
  }

  void _onEmailCheckSucceeded(
      EmailCheckSucceeded event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.emailChecked,
        email: event.email,
        emailCheckError: null));
  }

  void _onEmailCheckFailed(EmailCheckFailed event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.emailCheckFailure,
        emailCheckError: event.error,
        email: null));
  }

  Future<void> _onSignUpStarted(
      SignUpStarted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(status: SignUpStatus.signUpLoading));
    if (state.email != null) {
      final SignUpResult result =
          await _userRepository.signUp(state.email!, event.password);
      if (result.success) {
        add(SignUpSucceeded());
      } else {
        add(SignUpFailed(error: result.error));
      }
    } else {
      add(SignUpFailed());
    }
  }

  void _onSignUpSucceeded(SignUpSucceeded event, Emitter<SignUpState> emit) {
    emit(state.copyWith(status: SignUpStatus.signUpSucceeded));
  }

  void _onSignUpFailed(SignUpFailed event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.signUpFailure, signUpError: event.error));
  }

  void _onSignUpReset(SignUpReset event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.initial,
        email: null,
        password: null,
        emailCheckError: null,
        signUpError: null));
  }

  void _onPasswordReset(PasswordReset event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.initial, password: null, signUpError: null));
  }

  void _onEmailReset(EmailReset event, Emitter<SignUpState> emit) {
    emit(state.copyWith(status: SignUpStatus.initial, emailCheckError: null));
  }
}
