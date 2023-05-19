import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';

import '../note_page/note_page_bloc.dart';
import 'note_page.dart';

class NotePageProvider extends MultiBlocProvider {
  final NotePageBloc notePageBloc;
  final SignInPageBloc signInPageBloc;
  NotePageProvider(
      {required this.notePageBloc, required this.signInPageBloc, Key? key})
      : super(
          key: key,
          providers: [
            BlocProvider(create: (context) => notePageBloc),
            BlocProvider(create: (context) => signInPageBloc),
          ],
          child: const NotePage(),
        );
}
