import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/home_page/home_page_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';

import '../note_page/note_page_bloc.dart';
import 'home_page_view.dart';

class HomePageProvider extends MultiBlocProvider {
  final SignInPageBloc bloc;
  HomePageProvider({required this.bloc, Key? key})
      : super(
          key: key,
          providers: [
            BlocProvider(create: (context) => HomePageBloc()),
            BlocProvider(create: (context) => NotePageBloc()),
            BlocProvider(create: (context) => bloc),
          ],
          child: const HomePage(),
        );
}
