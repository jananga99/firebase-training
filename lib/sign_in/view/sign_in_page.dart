import 'package:flutter/material.dart';
import 'package:project1/sign_in/widgets/sign_in_form.dart';

import '../../common/constants.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleSignUp() {
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
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 35, color: Colors.lightBlue),
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
                            child: const Text(
                              "Don't have an account yet?",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                                onTap: handleSignUp,
                                child: const Text("Create an account",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.lightBlue))),
                          ),
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
