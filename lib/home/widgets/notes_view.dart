import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../bloc/notes_bloc.dart';
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
          NotesBloc(context.read<NoteRepository>())..add(NotesStarted()),
      child: BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (prev, state) =>
            prev.noteStatus != NotesStatus.failure ||
            state.noteStatus != NotesStatus.failure,
        builder: (context, state) {
          Widget returnWidget;
          switch (state.noteStatus) {
            case NotesStatus.initial:
              context.read<NotesBloc>().add(NotesStarted());
              returnWidget = const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
              break;
            case NotesStatus.loading:
              returnWidget = const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
              break;
            case NotesStatus.onProgress:
              returnWidget = ListView(
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
              break;
            case NotesStatus.failure:
              showMessage(context, Messages.getNotesFailed);
              returnWidget = const SizedBox();
              break;
            default:
              returnWidget = const SizedBox();
          }
          return returnWidget;
        },
      ),
    );
  }
}
