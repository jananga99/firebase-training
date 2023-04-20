import 'package:flutter/material.dart';
import 'package:project1/services/auth.service.dart';
import 'package:project1/utils/constants.dart';

import '../../utils/routes.dart';

class PasswordSignUpPageArguments {
  final String email;
  PasswordSignUpPageArguments(this.email);
}

class PasswordSignUpPage extends StatefulWidget {
  const PasswordSignUpPage({super.key});
  @override
  State<PasswordSignUpPage> createState() => _PasswordSignUpPageState();
}

class _PasswordSignUpPageState extends State<PasswordSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordInputController = TextEditingController();

  bool isContinueButtonDisabled() {
    return passwordInputController.text.isEmpty;
  }

  bool isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    passwordInputController.addListener(() {
      setState(() {
        isPasswordEmpty = passwordInputController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as PasswordSignUpPageArguments;

    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    Future<void> handleSignIn() async {
      dynamic res = await signIn(
          email: args.email, password: passwordInputController.text);
      if (res.runtimeType == String) {
        showMessage(res);
      } else {
        if (context.mounted) {
          Navigator.pushNamed(context, RouteConstants.homeRoute);
        } else {
          showMessage(Messages.signInFailed);
        }
      }
    }

    Future<void> handleSignUp() async {
      if (_formKey.currentState!.validate()) {
        dynamic res = await signUp(
            email: args.email, password: passwordInputController.text);
        if (res.runtimeType == String) {
          if (res == Messages.signUpFailedDuplicateEmail) {
            await handleSignIn();
          } else {
            showMessage(res);
          }
        } else {
          await handleSignIn();
        }
      }
    }

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
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text(
                          "Sign Up",
                          style:
                              TextStyle(fontSize: 35, color: Colors.lightBlue),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 300,
                              margin: EdgeInsets.all(20),
                              child: TextFormField(
                                controller: passwordInputController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: 'Password*',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an Password';
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
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.black12;
                                    }
                                    return Colors.blue;
                                  }),
                                  foregroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.white;
                                    }
                                    return Colors.white;
                                  }),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                onPressed:
                                    isPasswordEmpty ? null : handleSignUp,
                                child: const Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text('REGISTER ->'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
