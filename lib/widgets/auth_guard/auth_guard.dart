import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/repositories.dart';

import '../../services/auth_service.dart';
import '../../sign_in/view/sign_in_page.dart';

class AuthGuard extends StatefulWidget {
  final Widget _component;
  final UserRepository _userRepository;

  const AuthGuard(
      {super.key,
      required Widget component,
      required UserRepository userRepository})
      : _component = component,
        _userRepository = userRepository;

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
    return RepositoryProvider(
      create: (context) => widget._userRepository,
      child: Container(
          child: isAuthenticated ? widget._component : const SignInPage()),
    );
  }
}
