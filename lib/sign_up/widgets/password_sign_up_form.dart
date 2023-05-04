import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../bloc/sign_up_bloc.dart';

class PasswordSignUpForm extends StatefulWidget {
  const PasswordSignUpForm({super.key});

  @override
  State<PasswordSignUpForm> createState() => _PasswordSignUpFormState();
}

class _PasswordSignUpFormState extends State<PasswordSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordInputController =
      TextEditingController();

  late SignUpBloc _signUpBloc;

  bool isRegisterButtonDisabled() {
    return isPasswordEmpty;
  }

  bool isPasswordEmpty = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final email = context.read<SignUpBloc>().state.email;
    if (email == null) {
      Navigator.of(context)
          .pushReplacementNamed(RouteConstants.signUpEmailRoute);
    }
    _passwordInputController.addListener(() {
      setState(() {
        isPasswordEmpty = _passwordInputController.text.isEmpty;
      });
    });
  }

  void handleSignUpSuccess() {
    _signUpBloc.add(SignUpReset());
    Navigator.of(context).pushReplacementNamed(RouteConstants.homeRoute);
  }

  @override
  void dispose() {
    _passwordInputController.dispose();
    _signUpBloc.add(PasswordReset());
    super.dispose();
  }

  Future<void> handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      _signUpBloc.add(SignUpStarted(_passwordInputController.text));
      _passwordInputController.clear();
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
              controller: _passwordInputController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password*',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary),
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
                    return Theme.of(context).colorScheme.onSurface;
                  }
                  return Theme.of(context).colorScheme.primary;
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Theme.of(context).colorScheme.onBackground;
                  }
                  return Theme.of(context).colorScheme.onBackground;
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
              _signUpBloc = context.read<SignUpBloc>();
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
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
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
