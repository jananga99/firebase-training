import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';

class AuthGuardView extends StatelessWidget {
  final Widget child;

  const AuthGuardView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInPageBloc, SignInPageState>(
      buildWhen: (pre, current) => pre.user != current.user,
      builder: (context, state) {
        return state.status == SignInStatus.authorized && state.user != null
            ? child
            : const SignInPage();
      },
    );
  }
}
