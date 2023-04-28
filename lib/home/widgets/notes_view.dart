import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/home/repositories/note_repository.dart';

import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../bloc/notes/notes_bloc.dart';
import '../models/note.dart';
import 'note_card.dart';

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleCardPress(String id) {
      Navigator.of(context)
          .pushReplacementNamed(RouteConstants.noteViewRoute, arguments: id);
    }

    return BlocProvider(
      create: (context) =>
          NoteBloc(context.read<NoteRepository>())..add(NoteStarted()),
      child: BlocBuilder<NoteBloc, NoteState>(
        buildWhen: (prev, state) =>
            prev.runtimeType != NoteFail || state.runtimeType != NoteFail,
        builder: (context, state) {
          if (state is NoteInitial) {
            context.read<NoteBloc>().add(NoteStarted());
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          } else if (state is NoteInProgress) {
            return ListView(
              shrinkWrap: true,
              children: state.notes
                  .map((Note note) {
                    return TextButton(
                      onPressed: () {
                        if (note.id != null) {
                          handleCardPress(note.id!);
                        }
                      },
                      child: NoteCard(note),
                    );
                  })
                  .toList()
                  .cast(),
            );
          } else if (state is NoteFail) {
            showMessage(context, Messages.getNotesFailed);
            return const SizedBox();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
