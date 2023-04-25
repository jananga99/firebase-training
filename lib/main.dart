import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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

  // runApp(const MyApp());
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (BuildContext context) => const MyApp(),
  ));
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
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
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
