import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_up_page/sign_up_page_bloc.dart';
import 'package:project1/view/sign_up_page/widgets/email_sign_up_form.dart';
import 'package:project1/widgets/custom/constants.dart';
import 'package:project1/widgets/custom/custom_colors.dart';

import '../../home_page/home_page_provider.dart';
import '../../home_page/home_page_view.dart';
import '../../sign_in_page/auth_guard_provider.dart';
import '../../sign_in_page/sign_in_page_bloc.dart';

class EmailSignUpPage extends StatelessWidget {
  static const String ROUTE = 'email';

  const EmailSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpPageBloc = BlocProvider.of<SignUpPageBloc>(context);

    Future<void> handleSignIn() async {
      signUpPageBloc.add(ResetSignUpEvent());
      final signInPageBloc = SignInPageBloc();
      await Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: HomePage.ROUTE),
            builder: (context) => AuthGuardProvider(
              bloc: signInPageBloc,
              component: HomePageProvider(
                bloc: signInPageBloc,
              ),
            ),
          ));
    }

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(Assets.logo, width: 25, height: 25),
                  ),
                  Text("Dear Diary",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 35, color: CustomColors.LIGHT_BLUE),
                        )),
                    const EmailSignUpForm(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Already have an account?",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: InkWell(
                                  onTap: handleSignIn,
                                  child: const Text("Sign in",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: CustomColors.LIGHT_BLUE)))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
