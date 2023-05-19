import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';

import 'auth_guard_view.dart';

class AuthGuardProvider extends BlocProvider<SignInPageBloc> {
  final Widget component;
  final SignInPageBloc bloc;
  AuthGuardProvider({required this.component, required this.bloc, Key? key})
      : super(
          key: key,
          create: (context) => bloc,
          child: AuthGuardView(child: component),
        );
}
