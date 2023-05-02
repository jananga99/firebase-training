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
        backgroundColor: const Color(0xff00ffff),
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
                  const Text("Dear Diary",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(5),
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
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
                                  fontSize: 25, color: Colors.lightBlue),
                            )),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 35, color: Colors.lightBlue),
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
