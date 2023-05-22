import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_up_page/sign_up_page_bloc.dart';
import 'package:project1/view/sign_up_page/widgets/password_sign_up_form.dart';
import 'package:project1/widgets/custom/constants.dart';
import 'package:project1/widgets/custom/custom_colors.dart';

import '../providers/email_sign_up_page_provider.dart';
import 'email_sign_up_page.dart';

class PasswordSignUpPage extends StatelessWidget {
  static const String ROUTE = 'password';

  const PasswordSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final signUpPageBloc = BlocProvider.of<SignUpPageBloc>(context);

    void handleGoBack() {
      Navigator.push(
          context,
          MaterialPageRoute(
              settings: const RouteSettings(name: EmailSignUpPage.ROUTE),
              builder: (context) =>
                  EmailSignUpPageProvider(bloc: signUpPageBloc)));
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: handleGoBack,
                            child: const Text(
                              "<--",
                              style: TextStyle(
                                  fontSize: 25, color: CustomColors.LIGHT_BLUE),
                            )),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 35,
                            color: CustomColors.LIGHT_BLUE,
                          ),
                        )),
                    const PasswordSignUpForm()
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
