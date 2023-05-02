import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/home/home.dart';
import 'package:project1/note/note.dart';
import 'package:project1/repositories/repositories.dart';
import 'package:project1/sign_in/sign_in.dart';
import 'package:project1/sign_up/sign_up.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(App(
    noteRepository: NoteRepository(),
    userRepository: UserRepository(),
  ));
}

class App extends StatelessWidget {
  const App(
      {super.key,
      required NoteRepository noteRepository,
      required UserRepository userRepository})
      : _noteRepository = noteRepository,
        _userRepository = userRepository;

  final NoteRepository _noteRepository;
  final UserRepository _userRepository;

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
            return EmailSignUpPage(
              userRepository: _userRepository,
            );
          } else {
            return EmailSignUpPage(
              userRepository: _userRepository,
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
            return EmailSignUpPage(
              userRepository: _userRepository,
            );
          } else {
            return PasswordSignUpPage(
              userRepository: _userRepository,
              email: args.toString(),
            );
          }
        },
        RouteConstants.homeRoute: (context) => AuthGuard(
              component: HomePage(
                noteRepository: _noteRepository,
              ),
              userRepository: _userRepository,
            ),
        RouteConstants.noteViewRoute: (context) => AuthGuard(
              component: NotePage(
                noteRepository: _noteRepository,
              ),
              userRepository: _userRepository,
            )
      },
    );
  }
}
