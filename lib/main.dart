import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/screens/Home/HomePage.dart';
import 'package:project1/screens/SignUp/EmailSignUpPage.dart';
import 'package:project1/screens/SignUp/PasswordSignUpPage.dart';
import 'package:project1/utils/routes.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouteConstants.emailSignUpRoute,
      routes: {
        RouteConstants.homeRoute: (context) => const HomePage(),
        RouteConstants.emailSignUpRoute: (context) => const EmailSignUpPage(),
        RouteConstants.passwordSignUpRoute: (context) =>
            const PasswordSignUpPage(),
      },
    );
  }
}
