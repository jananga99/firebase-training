import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/db/model/note.dart';
import 'package:project1/view/home_page/home_page_bloc.dart';
import 'package:project1/view/home_page/widgets/note_card.dart';
import 'package:project1/view/note_page/note_page_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late HomePageBloc _notesBloc;

  @override
  void dispose() {
    _notesBloc.add(ResetFetchNotesEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NotePageBloc>(context);
    _notesBloc = BlocProvider.of<HomePageBloc>(context);

    void handleCardPress(String id) {
      noteBloc.add(StartFetchNoteEvent(id: id));
      Navigator.of(context).pushReplacementNamed(RouteConstants.noteViewRoute);
    }

    return BlocBuilder<HomePageBloc, HomePageState>(
      buildWhen: (pre, current) =>
          pre.fetchNotesStatus != FetchNotesStatus.failure ||
          current.fetchNotesStatus != FetchNotesStatus.failure,
      builder: (context, state) {
        Widget returnWidget;
        switch (state.fetchNotesStatus) {
          case FetchNotesStatus.initial:
            _notesBloc.add(StartFetchNotesEvent());
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
