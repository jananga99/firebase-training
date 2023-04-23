import 'package:flutter/material.dart';

import '../../services/auth.service.dart';
import '../../utils/constants.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  bool isEmailEmpty = true;
  bool isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    emailInputController.addListener(() {
      setState(() {
        isEmailEmpty = emailInputController.text.isEmpty;
      });
    });
    passwordInputController.addListener(() {
      setState(() {
        isPasswordEmpty = passwordInputController.text.isEmpty;
      });
    });
  }

  bool isSignInDisabled() {
    return isEmailEmpty || isPasswordEmpty;
  }

  void handleSignUp() {
    Navigator.pushNamed(context, RouteConstants.signUpRoute);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    Future<void> handleSignIn() async {
      setState(() {
        isLoading = true;
      });
      dynamic res = await signIn(
          email: emailInputController.text,
          password: passwordInputController.text);
      if (res.runtimeType == String) {
        showMessage(res);
      } else if (context.mounted) {
        Navigator.pushNamed(context, RouteConstants.homeRoute);
      } else {
        showMessage(Messages.signInFailed);
      }
      passwordInputController.clear();
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
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
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                                return 'Please enter the Email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: const EdgeInsets.all(20),
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
                                return 'Please enter the Password';
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
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.black12;
                                }
                                return Colors.blue;
                              }),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
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
                            onPressed: isSignInDisabled() ? null : handleSignIn,
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('SIGN IN  ->'),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: const Text(
                            "Don't have an account yet?",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                              onTap: handleSignUp,
                              child: const Text("Create an account",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.lightBlue))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
