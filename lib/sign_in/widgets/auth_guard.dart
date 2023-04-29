import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/repositories.dart';

import '../bloc/sign_in_bloc.dart';
import '../view/sign_in_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget _component;
  final UserRepository _userRepository;

  const AuthGuard(
      {super.key,
      required Widget component,
      required UserRepository userRepository})
      : _component = component,
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _userRepository,
      child: BlocProvider(
        create: (context) => SignInBloc(_userRepository),
        child: BlocBuilder<SignInBloc, SignInState>(
          buildWhen: (previous, current) => previous.user != current.user,
          builder: (context, state) {
            return state.user != null ? _component : const SignInPage();
          },
        ),
      ),
    );
  }
}
