import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/header_bar/header_bar.dart';
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

  final UserRepository userRepository = UserRepository();
  final NoteRepository noteRepository = NoteRepository();
  final BatteryRepository batteryRepository = BatteryRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SignUpBloc>(
          create: (BuildContext context) => SignUpBloc(userRepository)),
      BlocProvider<SignInBloc>(
          create: (BuildContext context) => SignInBloc(userRepository)),
      BlocProvider<NotesBloc>(
          create: (BuildContext context) => NotesBloc(noteRepository)),
      BlocProvider<NoteBloc>(
          create: (BuildContext context) => NoteBloc(noteRepository)),
      BlocProvider<BatteryBloc>(
          create: (BuildContext context) => BatteryBloc(batteryRepository)),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RouteConstants.homeRoute,
        routes: {
          RouteConstants.signUpEmailRoute: (context) => const EmailSignUpPage(),
          RouteConstants.signUpPasswordRoute: (context) =>
              const PasswordSignUpPage(),
          RouteConstants.homeRoute: (context) => const AuthGuard(
                component: HomePage(),
              ),
          RouteConstants.noteViewRoute: (context) => const AuthGuard(
                component: NotePage(),
              )
        },
      ),
    );
  }
}
