import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/screens/Home/HomePage.dart';
import 'package:project1/utils/routes.dart';
import 'package:project1/widgets/AuthGuard/AuthGuard.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        RouteConstants.homeRoute: (context) =>
            const AuthGuard(component: HomePage())
      },
    );
  }
}
