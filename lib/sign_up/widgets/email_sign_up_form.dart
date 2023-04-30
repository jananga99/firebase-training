import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../bloc/sign_up_bloc.dart';

class EmailSignUpForm extends StatefulWidget {
  final String? _email;

  const EmailSignUpForm({super.key, String? email}) : _email = email;

  @override
  State<EmailSignUpForm> createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailInputController = TextEditingController();

  bool isContinueButtonDisabled() {
    return isEmailEmpty;
  }

  bool isEmailEmpty = true;

  @override
  void initState() {
    super.initState();
    if (widget._email != null && widget._email!.isNotEmpty) {
      emailInputController.text = widget._email!;
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

  void handleContinue() async {
    if (_formKey.currentState!.validate()) {
      context
          .read<SignUpBloc>()
          .add(EmailCheckStarted(emailInputController.text));
    }
  }

  void handleEmailChecked() {
    Navigator.of(context).pushReplacementNamed(
        RouteConstants.signUpPasswordRoute,
        arguments: emailInputController.text);
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
              controller: emailInputController,
              decoration: InputDecoration(
                hintText: 'Email*',
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
