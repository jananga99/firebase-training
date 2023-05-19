import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project1/view/home_page/home_page_provider.dart';
import 'package:project1/view/sign_in_page/auth_guard_provider.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';
import 'package:project1/widgets/custom/custom_themes.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInPageBloc bloc = SignInPageBloc();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: CustomThemes.lightTheme(context),
        home: AuthGuardProvider(
          bloc: bloc,
          component: HomePageProvider(
            bloc: bloc,
          ),
        ),
      ),
    );
  }
}
