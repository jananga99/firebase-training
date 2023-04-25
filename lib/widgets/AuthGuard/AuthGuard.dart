import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:project1/services/auth.service.dart';

import '../../screens/SignIn/SignInPage.dart';

class AuthGuard extends StatefulWidget {
  final Widget component;

  const AuthGuard({Key? key, required this.component}) : super(key: key);

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool isAuthenticated = getCurrentUser() != null;
  late StreamSubscription<User?> subscription;

  @override
  void initState() {
    super.initState();
    subscription = FirebaseAuth.instance.userChanges().listen((User? user) {
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
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAuthenticated ? widget.component : const SignInPage();
  }
}
