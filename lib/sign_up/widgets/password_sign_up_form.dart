import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../bloc/sign_up_bloc.dart';

class PasswordSignUpForm extends StatefulWidget {
  final String _email;
  const PasswordSignUpForm({super.key, required String email}) : _email = email;

  @override
  State<PasswordSignUpForm> createState() => _PasswordSignUpFormState();
}

class _PasswordSignUpFormState extends State<PasswordSignUpForm> {
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

  void handleSignUpSuccess() {
    Navigator.of(context).pushReplacementNamed(RouteConstants.homeRoute);
  }

  @override
  void dispose() {
    passwordInputController.dispose();
    super.dispose();
  }

  Future<void> handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      context
          .read<SignUpBloc>()
          .add(SignUpStarted(widget._email, passwordInputController.text));
      passwordInputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
          BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state.status == SignUpStatus.signUpSucceeded) {
                handleSignUpSuccess();
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Visibility(
                      visible: state.status == SignUpStatus.signUpLoading,
                      child: const CircularProgressIndicator()),
                  Visibility(
                      visible: state.status == SignUpStatus.signUpFailure,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            state.signUpError ?? '',
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
