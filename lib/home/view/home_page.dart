import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/home/widgets/note_add_form.dart';
import 'package:project1/home/widgets/notes_view.dart';

import '../../header_bar/header_bar.dart';
import '../../repositories/repositories.dart';
import '../bloc/notes_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required NoteRepository noteRepository})
      : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      backgroundColor: const Color(0xff00ffff),
      body: RepositoryProvider(
        create: (context) => _noteRepository,
        child: BlocProvider(
          create: (context) => NotesBloc(context.read<NoteRepository>())
            ..add(FetchNotesStarted()),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Home",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "You are here: Home",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      )),
                  const NoteAddForm(),
                  const NotesView()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
