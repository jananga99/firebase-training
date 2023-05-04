import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../note/note.dart';
import '../../repositories/repositories.dart';
import '../bloc/notes_bloc.dart';
import 'note_card.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late NotesBloc _notesBloc;
  late NoteBloc _noteBloc;

  @override
  void dispose() {
    _notesBloc.add(FetchNotesReset());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _noteBloc = context.read<NoteBloc>();

    void handleCardPress(String id) {
      _noteBloc.add(NoteStarted(id: id));
      Navigator.of(context).pushReplacementNamed(RouteConstants.noteViewRoute);
    }

    return BlocBuilder<NotesBloc, NotesState>(
      buildWhen: (prev, state) =>
          prev.fetchNotesStatus != FetchNotesStatus.failure ||
          state.fetchNotesStatus != FetchNotesStatus.failure,
      builder: (context, state) {
        _notesBloc = context.read<NotesBloc>();
        Widget returnWidget;
        switch (state.fetchNotesStatus) {
          case FetchNotesStatus.initial:
            _notesBloc.add(FetchNotesStarted());
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
