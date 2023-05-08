import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/home/cubit/notes_cubit.dart';

import '../../common/constants.dart';
import '../../note/note.dart';
import '../../repositories/repositories.dart';
import 'note_card.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late NotesCubit _notesCubit;
  late NoteCubit _noteCubit;

  @override
  void dispose() {
    _notesCubit.resetFetchingNotes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _noteCubit = context.read<NoteCubit>();

    void handleCardPress(String id) {
      _noteCubit.fetchNote(id);
      Navigator.of(context).pushReplacementNamed(RouteConstants.noteViewRoute);
    }

    return BlocBuilder<NotesCubit, NotesState>(
      buildWhen: (prev, state) =>
          prev.fetchNotesStatus != FetchNotesStatus.failure ||
          state.fetchNotesStatus != FetchNotesStatus.failure,
      builder: (context, state) {
        _notesCubit = context.read<NotesCubit>();
        Widget returnWidget;
        switch (state.fetchNotesStatus) {
          case FetchNotesStatus.initial:
            _notesCubit.fetchNotes();
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
