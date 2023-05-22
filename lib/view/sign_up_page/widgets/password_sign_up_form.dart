import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_in_page/auth_guard_provider.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';
import 'package:project1/view/sign_up_page/sign_up_page_bloc.dart';

import '../../home_page/home_page_provider.dart';
import '../../home_page/home_page_view.dart';
import '../providers/email_sign_up_page_provider.dart';
import '../views/email_sign_up_page.dart';

class PasswordSignUpForm extends StatefulWidget {
  const PasswordSignUpForm({super.key});

  @override
  State<PasswordSignUpForm> createState() => _PasswordSignUpFormState();
}

class _PasswordSignUpFormState extends State<PasswordSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordInputController =
      TextEditingController();

  late SignUpPageBloc _signUpPageBloc;

  bool isRegisterButtonDisabled() {
    return isPasswordEmpty;
  }

  bool isPasswordEmpty = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final email = context.read<SignUpPageBloc>().state.email;
    if (email == null) {
      Future(() {
        Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: EmailSignUpPage.ROUTE),
              builder: (context) => EmailSignUpPageProvider(
                bloc: _signUpPageBloc,
              ),
            ));
      });
    }
    _passwordInputController.addListener(() {
      setState(() {
        isPasswordEmpty = _passwordInputController.text.isEmpty;
      });
    });
  }

  Future<void> handleSignUpSuccess() async {
    _signUpPageBloc.add(ResetSignUpEvent());
    final signInBloc = SignInPageBloc();
    await Navigator.push(
        context,
        MaterialPageRoute(
            settings: const RouteSettings(name: HomePage.ROUTE),
            builder: (context) => AuthGuardProvider(
                component: HomePageProvider(
                  bloc: signInBloc,
                ),
                bloc: signInBloc)));
  }

  @override
  void dispose() {
    _passwordInputController.dispose();
    _signUpPageBloc.add(ResetPasswordEmailEvent());
    super.dispose();
  }

  Future<void> handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      _signUpPageBloc.add(SignUpEvent(_passwordInputController.text));
      _passwordInputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    _signUpPageBloc = BlocProvider.of<SignUpPageBloc>(context);
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
          BlocConsumer<SignUpPageBloc, SignUpPageState>(
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
