import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view/sign_in_page/sign_in_page.dart';
import '../view/sign_in_page/sign_in_page_bloc.dart';

class AuthGuard extends StatelessWidget {
  final Widget _component;

  const AuthGuard({super.key, required Widget component})
      : _component = component;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInPageBloc, SignInPageState>(
      buildWhen: (pre, current) => pre.user != current.user,
      builder: (context, state) {
        return state.status == SignInStatus.authorized && state.user != null
            ? _component
            : const SignInPage();
      },
    );
  }
}
