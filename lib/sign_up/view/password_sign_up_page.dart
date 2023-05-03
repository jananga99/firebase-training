import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../widgets/widgets.dart';

class PasswordSignUpPage extends StatelessWidget {
  const PasswordSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleGoBack() {
      Navigator.pushReplacementNamed(context, RouteConstants.signUpEmailRoute);
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
                            child: Text(
                              "<--",
                              style: TextStyle(
                                  fontSize: 25,
                                  color:
                                      Theme.of(context).secondaryHeaderColor),
                            )),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 35,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                    ),
                    const PasswordSignUpForm()
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
