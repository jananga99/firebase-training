import 'package:firebase_auth/firebase_auth.dart';

import '../../common/constants.dart';
import 'models/models.dart';

export 'models/models.dart';

class UserRepository {
  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;

  Stream<User?> getUserStream() {
    return _firebaseAuth.authStateChanges();
  }

  Future<SignInResult> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return SignInResult(success: true, user: userCredential.user);
    } on FirebaseAuthException catch (e) {
      late String errorMessage;
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-email') {
        errorMessage = Messages.signInFailedInvalidEmailPassword;
      } else {
        errorMessage = Messages.signInFailed;
      }
      return SignInResult(success: false, error: errorMessage);
    } catch (e) {
      return SignInResult(success: false);
    }
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<SignUpEmailCheckResult> isEmailAlreadyRegistered(String email) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return SignUpEmailCheckResult(
          success: true, isRegistered: signInMethods.isNotEmpty);
    } catch (e) {
      return SignUpEmailCheckResult(
          success: false, error: Messages.emailCheckFailed);
    }
  }

  Future<SignUpResult> signUp(String email, String password) async {
    late String errorMessage;
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return SignUpResult(success: true);
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
    return SignUpResult(success: false, error: errorMessage);
  }
}
