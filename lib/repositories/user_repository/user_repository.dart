import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/constants.dart';
import 'models/models.dart';

class UserRepository {
  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;

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

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
