import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../common/constants.dart';

class EmailSignUpPage extends StatefulWidget {
  final String? email;
  const EmailSignUpPage({Key? key, this.email}) : super(key: key);

  @override
  State<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController = TextEditingController();

  bool isContinueButtonDisabled() {
    return isEmailEmpty;
  }

  bool isEmailEmpty = true;

  @override
  void initState() {
    super.initState();
    if (widget.email != null && widget.email!.isNotEmpty) {
      emailInputController.text = widget.email!;
      setState(() {
        isEmailEmpty = false;
      });
    }
    emailInputController.addListener(() {
      setState(() {
        isEmailEmpty = emailInputController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    emailInputController.dispose();
    super.dispose();
  }

  void handleSignIn() {
    Navigator.pushReplacementNamed(context, RouteConstants.homeRoute);
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
          } else if (context.mounted) {
            Navigator.pushReplacementNamed(
                context, RouteConstants.signUpPasswordRoute,
                arguments: emailInputController.text);
          } else {
            showMessage(Messages.emailCheckFailed);
          }
        } else {
          showMessage(Messages.emailCheckFailed);
        }
      }
      setState(() {
        isLoading = false;
      });
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
                              onPressed: isContinueButtonDisabled()
                                  ? null
                                  : handleContinue,
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
                              style:
                                  TextStyle(fontSize: 15, color: Colors.black),
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
        )));
  }
}
