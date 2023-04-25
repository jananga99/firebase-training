import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';

class PasswordSignUp extends StatefulWidget {
  final String email;
  final Function setSignUpFlowState;

  const PasswordSignUp(
      {Key? key, required this.email, required this.setSignUpFlowState})
      : super(key: key);

  @override
  State<PasswordSignUp> createState() => _PasswordSignUpState();
}

class _PasswordSignUpState extends State<PasswordSignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordInputController = TextEditingController();

  bool isRegisterButtonDisabled() {
    return isPasswordEmpty;
  }

  bool isPasswordEmpty = true;
  bool isLoading = false;

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
        dynamic res = await signUp(
            email: widget.email, password: passwordInputController.text);
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
      widget.setSignUpFlowState(SignUpFlowState.email);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
                onPressed: handleGoBack,
                child: const Text(
                  "<--",
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
                  controller: passwordInputController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password*',
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
                  onPressed: isRegisterButtonDisabled() ? null : handleSignUp,
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
    );
  }
}
