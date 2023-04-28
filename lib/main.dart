import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/home/home.dart';
import 'package:project1/repositories/repositories.dart';
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

  runApp(App(
    noteRepository: NoteRepository(),
  ));
}

class App extends StatelessWidget {
  const App({super.key, required NoteRepository noteRepository})
      : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;

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
        RouteConstants.homeRoute: (context) => AuthGuard(
                component: HomePage(
              noteRepository: _noteRepository,
            )),
        RouteConstants.noteViewRoute: (context) =>
            const AuthGuard(component: NotePage())
      },
    );
  }
}
