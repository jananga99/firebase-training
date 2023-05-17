import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  final FirebaseAuth _firebaseAuth;

  Stream<User?> getUserStream() {
    return _firebaseAuth.authStateChanges();
  }

  Future<User?> signIn(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> isEmailAlreadyRegistered(String email) async {
    return (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email))
        .isNotEmpty;
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
