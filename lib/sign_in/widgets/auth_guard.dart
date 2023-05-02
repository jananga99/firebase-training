import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sign_in_bloc.dart';
import '../view/sign_in_page.dart';

class AuthGuard extends StatelessWidget {
  final Widget _component;

  const AuthGuard({super.key, required Widget component})
      : _component = component;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      buildWhen: (previous, current) => previous.user != current.user,
      builder: (context, state) {
        return state.status == SignInStatus.authorized && state.user != null
            ? _component
            : const SignInPage();
      },
    );
  }
}
