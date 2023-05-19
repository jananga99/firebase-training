import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_up_page/views/email_sign_up_page.dart';

import '../sign_up_page_bloc.dart';

class EmailSignUpPageProvider extends BlocProvider<SignUpPageBloc> {
  final SignUpPageBloc bloc;
  EmailSignUpPageProvider({required this.bloc, Key? key})
      : super(
          key: key,
          create: (context) => bloc,
          child: const EmailSignUpPage(),
        );
}
