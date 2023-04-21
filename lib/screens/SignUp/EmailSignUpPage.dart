import 'package:flutter/material.dart';
import 'package:project1/screens/SignUp/PasswordSignUpPage.dart';
import 'package:project1/utils/routes.dart';

class EmailSignUpPage extends StatefulWidget {
  const EmailSignUpPage({super.key});
  @override
  State<EmailSignUpPage> createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController = TextEditingController();

  bool isContinueButtonDisabled() {
    return emailInputController.text.isEmpty;
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

  @override
  Widget build(BuildContext context) {
    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    void handleContinue() {
      if (_formKey.currentState!.validate()) {
        Navigator.pushNamed(
          context,
          RouteConstants.passwordSignUpRoute,
          arguments: PasswordSignUpPageArguments(emailInputController.text),
        );
      } else {
        showMessage("Enter a valid email");
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
                                onPressed: isEmailEmpty ? null : handleContinue,
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
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
