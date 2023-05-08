import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  late AuthCubit _authCubit;

  bool isEmailEmpty = true;
  bool isPasswordEmpty = true;

  @override
  void initState() {
    super.initState();
    _emailInputController.addListener(() {
      setState(() {
        isEmailEmpty = _emailInputController.text.isEmpty;
      });
    });
    _passwordInputController.addListener(() {
      setState(() {
        isPasswordEmpty = _passwordInputController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    _passwordInputController.dispose();
    super.dispose();
  }

  bool isSignInDisabled() {
    return isEmailEmpty || isPasswordEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignIn() async {
      if (_formKey.currentState!.validate()) {
        _authCubit.signIn(
            email: _emailInputController.text,
            password: _passwordInputController.text);
      }
      _passwordInputController.clear();
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            margin: const EdgeInsets.all(20),
            child: TextFormField(
              controller: _emailInputController,
              decoration: InputDecoration(
                hintText: 'Email*',
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
              onPressed: isSignInDisabled() ? null : handleSignIn,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text('SIGN IN  ->'),
              ),
            ),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (prev, current) => prev.status != current.status,
            builder: (context, state) {
              _authCubit = context.read<AuthCubit>();
              return Column(
                children: [
                  Visibility(
                      visible: state.status == AuthStatus.loading,
                      child: const CircularProgressIndicator()),
                  Visibility(
                      visible: state.status == AuthStatus.failure,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            state.error ?? '',
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
