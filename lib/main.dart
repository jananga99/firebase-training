import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/screens/home/home.dart';
import 'package:project1/screens/note/note.dart';
import 'package:project1/screens/sign_up/sign_up.dart';
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
        RouteConstants.signUpRoute: (context) => const SignUpPage(),
        RouteConstants.homeRoute: (context) =>
            const AuthGuard(component: HomePage()),
        RouteConstants.noteViewRoute: (context) =>
            const AuthGuard(component: NotePage())
      },
    );
  }
}
