import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../note/note.dart';
import '../../repositories/repositories.dart';
import '../bloc/notes_bloc.dart';
import 'note_card.dart';

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleCardPress(String id) {
      context.read<NoteBloc>().add(NoteStarted(id: id));
      Navigator.of(context).pushReplacementNamed(RouteConstants.noteViewRoute);
    }

    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (prev, state) =>
          prev.fetchNotesStatus != FetchNotesStatus.failure ||
          state.fetchNotesStatus != FetchNotesStatus.failure,
      builder: (context, state) {
        Widget returnWidget;
        switch (state.fetchNotesStatus) {
          case FetchNotesStatus.initial:
            context.read<NotesBloc>().add(FetchNotesStarted());
            returnWidget = Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
            break;
          case FetchNotesStatus.loading:
            returnWidget = Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
            break;
          case FetchNotesStatus.onProgress:
            returnWidget = ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: state.fetchNotes
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
          case FetchNotesStatus.failure:
            returnWidget = const Text(Messages.getNotesFailed);
            break;
          default:
            returnWidget = const SizedBox();
        }
        return returnWidget;
      },
    );
  }
}
