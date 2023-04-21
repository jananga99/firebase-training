import 'package:flutter/material.dart';
import 'package:project1/widgets/SignUp/EmailSignUp.dart';
import 'package:project1/widgets/SignUp/PasswordSignUp.dart';

import '../../utils/enums.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpFlowState signUpFlowState = SignUpFlowState.email;
  String email = '';

  void setSignUpFlowState(SignUpFlowState signUpFlowState) {
    if (signUpFlowState == SignUpFlowState.email || email.isNotEmpty) {
      setState(() {
        this.signUpFlowState = signUpFlowState;
      });
    }
  }

  void setEmail(String email) {
    setState(() {
      this.email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget formWidget =
        signUpFlowState == SignUpFlowState.password && email.isNotEmpty
            ? PasswordSignUp(
                email: email,
                setSignUpFlowState: setSignUpFlowState,
              )
            : EmailSignUp(
                setEmail: setEmail, setSignUpFlowState: setSignUpFlowState);

    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Dear Diary",
                style: TextStyle(fontSize: 18, color: Colors.white)),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[formWidget],
              ),
            ),
          ],
        )));
  }
}
