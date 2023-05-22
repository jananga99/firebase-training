import 'package:flutter/material.dart';
import 'package:project1/view/sign_in_page/sign_in_form.dart';
import 'package:project1/view/sign_up_page/sign_up_page_bloc.dart';
import 'package:project1/view/sign_up_page/views/email_sign_up_page.dart';
import 'package:project1/widgets/custom/constants.dart';
import 'package:project1/widgets/custom/custom_colors.dart';

import '../sign_up_page/providers/email_sign_up_page_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignUp() async {
      await Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: EmailSignUpPage.ROUTE),
            builder: (context) => EmailSignUpPageProvider(
              bloc: SignUpPageBloc(),
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
                          color: Theme.of(context).colorScheme.onBackground)),
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
                        "Sign In",
                        style: TextStyle(
                            fontSize: 35, color: CustomColors.LIGHT_BLUE),
                      ),
                    ),
                    const SignInForm(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Don't have an account yet?",
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
                              onTap: handleSignUp,
                              child: const Text("Create an account",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: CustomColors.LIGHT_BLUE)),
                            ),
                          )
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
