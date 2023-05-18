import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/common/theme.dart';
import 'package:project1/view/home_page/home_page_provider.dart';
import 'package:project1/view/note_page/note_page.dart';
import 'package:project1/view/note_page/note_page_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';
import 'package:project1/view/sign_up_page/sign_up_page_bloc.dart';
import 'package:project1/view/sign_up_page/views/email_sign_up_page.dart';
import 'package:project1/view/sign_up_page/views/password_sign_up_page.dart';
import 'package:project1/widgets/auth_guard.dart';
import 'package:project1/widgets/header_bar/header_bar_bloc.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SignUpPageBloc>(
          create: (BuildContext context) => SignUpPageBloc()),
      BlocProvider<SignInPageBloc>(
          create: (BuildContext context) => SignInPageBloc()),
      BlocProvider<NotePageBloc>(
          create: (BuildContext context) => NotePageBloc()),
      BlocProvider<HeaderBarBloc>(
          create: (BuildContext context) => HeaderBarBloc()),
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
        theme: CustomTheme.getThemeData(),
        initialRoute: RouteConstants.homeRoute,
        routes: {
          RouteConstants.signUpEmailRoute: (context) => const EmailSignUpPage(),
          RouteConstants.signUpPasswordRoute: (context) =>
              const PasswordSignUpPage(),
          RouteConstants.homeRoute: (context) => AuthGuard(
                component: HomePageProvider(),
              ),
          RouteConstants.noteViewRoute: (context) => const AuthGuard(
                component: NotePage(),
              )
        },
      ),
    );
  }
}
