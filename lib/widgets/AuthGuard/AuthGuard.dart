import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../screens/SignIn/SignInPage.dart';

class AuthGuard extends StatefulWidget {
  final Widget component;

  const AuthGuard({Key? key, required this.component}) : super(key: key);

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null && isAuthenticated) {
        setState(() {
          isAuthenticated = false;
        });
      } else if (user != null && !isAuthenticated) {
        setState(() {
          isAuthenticated = true;
        });
      }
    });

    return isAuthenticated ? widget.component : const SignInPage();
  }
}
