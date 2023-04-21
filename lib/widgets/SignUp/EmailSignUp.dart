import 'package:flutter/material.dart';
import 'package:project1/utils/enums.dart';

import '../../utils/routes.dart';

class EmailSignUp extends StatefulWidget {
  final Function setEmail;
  final Function setSignUpFlowState;

  const EmailSignUp(
      {Key? key, required this.setEmail, required this.setSignUpFlowState})
      : super(key: key);

  @override
  State<EmailSignUp> createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController = TextEditingController();

  bool isContinueButtonDisabled() {
    return isEmailEmpty;
  }

  bool isEmailEmpty = true;

  @override
  void initState() {
    super.initState();
    emailInputController.addListener(() {
      setState(() {
        isEmailEmpty = emailInputController.text.isEmpty;
      });
    });
  }

  void handleSignIn() {
    Navigator.pushNamed(context, RouteConstants.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    void handleContinue() {
      if (_formKey.currentState!.validate()) {
        widget.setEmail(emailInputController.text);
        widget.setSignUpFlowState(SignUpFlowState.password);
      } else {
        showMessage("Enter a valid email");
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            OutlinedButton(
                onPressed: handleSignIn,
                child: const Text(
                  "Sign In",
                  style: TextStyle(fontSize: 25, color: Colors.lightBlue),
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
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                margin: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: emailInputController,
                  decoration: InputDecoration(
                    hintText: 'Email*',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                width: 300,
                // padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.black12;
                      }
                      return Colors.blue;
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.white;
                      }
                      return Colors.white;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: isContinueButtonDisabled() ? null : handleContinue,
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('CONTINUE ->'),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
