import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/repositories.dart';
import 'package:project1/sign_up/bloc/sign_up_bloc.dart';

import '../../common/constants.dart';
import '../widgets/widgets.dart';

class PasswordSignUpPage extends StatelessWidget {
  final UserRepository _userRepository;
  final String _email;
  const PasswordSignUpPage(
      {super.key,
      required UserRepository userRepository,
      required String email})
      : _userRepository = userRepository,
        _email = email;

  @override
  Widget build(BuildContext context) {
    void handleGoBack() {
      Navigator.pushReplacementNamed(context, RouteConstants.signUpEmailRoute,
          arguments: _email);
    }

    return RepositoryProvider(
      create: (context) => _userRepository,
      child: BlocProvider(
        create: (context) => SignUpBloc(_userRepository),
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
                            style: TextStyle(
                                fontSize: 35, color: Colors.lightBlue),
                          ),
                        ),
                        PasswordSignUpForm(email: _email)
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
