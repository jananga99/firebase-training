import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../sign_up_page_bloc.dart';
import '../views/password_sign_up_page.dart';

class PasswordSignUpPageProvider extends BlocProvider<SignUpPageBloc> {
  final SignUpPageBloc bloc;
  PasswordSignUpPageProvider({required this.bloc, Key? key})
      : super(
          key: key,
          create: (context) => bloc,
          child: const PasswordSignUpPage(),
        );
}
