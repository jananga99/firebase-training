import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../bloc/sign_up_bloc.dart';

class EmailSignUpForm extends StatefulWidget {
  const EmailSignUpForm({super.key});

  @override
  State<EmailSignUpForm> createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailInputController = TextEditingController();

  late SignUpBloc _signUpBloc;

  bool isContinueButtonDisabled() {
    return isEmailEmpty;
  }

  bool isEmailEmpty = true;

  @override
  void initState() {
    super.initState();

    final email = context.read<SignUpBloc>().state.email;

    if (email != null && email.isNotEmpty) {
      _emailInputController.text = email;
      setState(() {
        isEmailEmpty = false;
      });
    }
    _emailInputController.addListener(() {
      setState(() {
        isEmailEmpty = _emailInputController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailInputController.dispose();
    super.dispose();
  }

  void handleContinue() async {
    if (_formKey.currentState!.validate()) {
      _signUpBloc.add(EmailCheckStarted(_emailInputController.text));
    }
  }

  void handleEmailChecked() {
    _signUpBloc.add(EmailReset());
    Navigator.of(context).pushReplacementNamed(
        RouteConstants.signUpPasswordRoute,
        arguments: context.read<SignUpBloc>());
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
              onPressed: isContinueButtonDisabled() ? null : handleContinue,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text('CONTINUE ->'),
              ),
            ),
          ),
          BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state.status == SignUpStatus.emailChecked) {
                handleEmailChecked();
              }
            },
            builder: (context, state) {
              _signUpBloc = context.read<SignUpBloc>();
              return Column(
                children: [
                  Visibility(
                      visible: state.status == SignUpStatus.emailChecking,
                      child: const CircularProgressIndicator()),
                  Visibility(
                      visible: state.status == SignUpStatus.emailCheckFailure,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            state.emailCheckError ?? '',
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
