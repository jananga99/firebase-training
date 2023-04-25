import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:project1/utils/constants.dart';
import 'package:project1/utils/enums.dart';

import '../../services/auth.service.dart';

class EmailSignUp extends StatefulWidget {
  final Function setEmail;
  final Function setSignUpFlowState;
  final Function getEmail;

  const EmailSignUp(
      {Key? key,
      required this.setEmail,
      required this.setSignUpFlowState,
      required this.getEmail})
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
      emailInputController.text = widget.getEmail();
      setState(() {
        isEmailEmpty = emailInputController.text.isEmpty;
      });
    });
  }

  void handleSignIn() {
    Navigator.pushNamed(context, RouteConstants.homeRoute);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    void handleContinue() async {
      setState(() {
        isLoading = true;
      });
      if (_formKey.currentState!.validate()) {
        final res = await isEmailAlreadyRegistered(emailInputController.text);
        if (res.runtimeType == String) {
          showMessage(res);
        } else if (res.runtimeType == bool) {
          if (res) {
            showMessage(Messages.signUpFailedDuplicateEmail);
          } else {
            widget.setEmail(emailInputController.text);
            widget.setSignUpFlowState(SignUpFlowState.password);
          }
        } else {
          showMessage(Messages.emailCheckFailed);
        }
      } else {
        showMessage("Enter a valid email");
      }
      setState(() {
        isLoading = false;
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
                    } else if (!EmailValidator.validate(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                width: 300,
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
              Container(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  "Already have an account?",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                    onTap: handleSignIn,
                    child: const Text("Sign in",
                        style:
                            TextStyle(fontSize: 15, color: Colors.lightBlue))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
