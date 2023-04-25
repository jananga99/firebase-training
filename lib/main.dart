import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/screens/home/home.dart';
import 'package:project1/screens/note/note.dart';
import 'package:project1/screens/sign_up/email_sign_up.dart';
import 'package:project1/screens/sign_up/password_sign_up.dart';
import 'package:project1/utils/constants.dart';
import 'package:project1/widgets/auth_guard/auth_guard.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteConstants.homeRoute,
      routes: {
        RouteConstants.signUpEmailRoute: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args == null ||
              args.runtimeType != String ||
              args.toString().isEmpty ||
              !EmailValidator.validate(args.toString())) {
            return const EmailSignUpPage();
          } else {
            return EmailSignUpPage(
              email: args.toString(),
            );
          }
        },
        RouteConstants.signUpPasswordRoute: (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args == null ||
              args.runtimeType != String ||
              args.toString().isEmpty ||
              !EmailValidator.validate(args.toString())) {
            return const EmailSignUpPage();
          } else {
            return PasswordSignUpPage(
              email: args.toString(),
            );
          }
        },
        RouteConstants.homeRoute: (context) =>
            const AuthGuard(component: HomePage()),
        RouteConstants.noteViewRoute: (context) =>
            const AuthGuard(component: NotePage())
      },
    );
  }
}
