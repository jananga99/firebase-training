import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/repositories.dart';
import 'package:project1/sign_up/widgets/email_sign_up_form.dart';

import '../../common/constants.dart';
import '../bloc/sign_up_bloc.dart';

class EmailSignUpPage extends StatelessWidget {
  final UserRepository _userRepository;
  final String? _email;

  const EmailSignUpPage(
      {super.key, required UserRepository userRepository, String? email})
      : _userRepository = userRepository,
        _email = email;

  @override
  Widget build(BuildContext context) {
    void handleSignIn() {
      Navigator.pushReplacementNamed(context, RouteConstants.homeRoute);
    }

    return RepositoryProvider(
      create: (context) => _userRepository,
      child: BlocProvider(
        create: (context) => SignUpBloc(context.read<UserRepository>()),
        child: Scaffold(
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
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
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 35, color: Colors.lightBlue),
                          ),
                        ),
                        EmailSignUpForm(email: _email),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: InkWell(
                                    onTap: handleSignIn,
                                    child: const Text("Sign in",
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
            ))),
      ),
    );
  }
}
