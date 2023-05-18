import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/note_page/note_page.dart';
import 'package:project1/view/note_page/note_page_bloc.dart';

class NotePageProvider extends BlocProvider<NotePageBloc> {
  NotePageProvider({
    Key? key,
  }) : super(
            key: key,
            create: (context) => NotePageBloc(),
            child: const NotePage());
}
