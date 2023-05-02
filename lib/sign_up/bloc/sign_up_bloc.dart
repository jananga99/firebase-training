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
  }

  Future<void> _onEmailCheckStarted(
      EmailCheckStarted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(status: SignUpStatus.emailChecking));
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
    emit(state.copyWith(status: SignUpStatus.emailChecked, email: event.email));
  }

  void _onEmailCheckFailed(EmailCheckFailed event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.emailCheckFailure, emailCheckError: event.error));
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
    emit(state.copyWith(
        status: SignUpStatus.signUpSucceeded, email: null, password: null));
  }

  void _onSignUpFailed(SignUpFailed event, Emitter<SignUpState> emit) {
    emit(state.copyWith(
        status: SignUpStatus.signUpFailure, signUpError: event.error));
  }
}
