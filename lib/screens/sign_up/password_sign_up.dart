import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/constants.dart';

class PasswordSignUpPage extends StatefulWidget {
  const PasswordSignUpPage({Key? key}) : super(key: key);

  @override
  State<PasswordSignUpPage> createState() => _PasswordSignUpPageState();
}

class _PasswordSignUpPageState extends State<PasswordSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordInputController = TextEditingController();

  bool isRegisterButtonDisabled() {
    return isPasswordEmpty;
  }

  bool isPasswordEmpty = true;
  bool isLoading = false;
  late String email;
  dynamic args;

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
  void dispose() {
    passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments;
    if (args == null ||
        args.runtimeType != String ||
        !EmailValidator.validate(args.toString())) {
      Navigator.pop(context);
    } else {
      email = args.toString();
    }

    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    Future<void> handleSignUp() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        await signOut();
        dynamic res =
            await signUp(email: email, password: passwordInputController.text);
        if (res.runtimeType == String) {
          showMessage(res);
        } else if (context.mounted) {
          Navigator.pushNamed(context, RouteConstants.homeRoute);
        } else {
          showMessage(Messages.signUpSuccess);
        }
        setState(() {
          isLoading = false;
        });
      }
      passwordInputController.clear();
    }

    void handleGoBack() {
      Navigator.pushNamed(context, RouteConstants.signUpEmailRoute,
          arguments: email);
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
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
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
                              onPressed: isRegisterButtonDisabled()
                                  ? null
                                  : handleSignUp,
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('REGISTER ->'),
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
                    )
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
