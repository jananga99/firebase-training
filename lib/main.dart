import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/screens/Home/HomePage.dart';
import 'package:project1/screens/Note/NotePage.dart';
import 'package:project1/screens/SignUp/SignUpPage.dart';
import 'package:project1/utils/constants.dart';
import 'package:project1/widgets/AuthGuard/AuthGuard.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: '',
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: Scaffold(
  //       body: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Text("Test"),
  //             ElevatedButton(
  //               onPressed: _getBatteryLevel,
  //               child: const Text('Get Battery Level'),
  //             ),
  //             Text(_batteryLevel),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
