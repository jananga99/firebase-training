import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/db/model/note.dart';
import 'package:project1/view/home_page/home_page_bloc.dart';
import 'package:project1/view/home_page/widgets/note_card.dart';
import 'package:project1/view/note_page/note_page_bloc.dart';
import 'package:project1/widgets/custom/constants.dart';

import '../../note_page/note_page.dart';
import '../../note_page/note_page_provider.dart';
import '../../sign_in_page/auth_guard_provider.dart';
import '../../sign_in_page/sign_in_page_bloc.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late HomePageBloc _homePageBloc;

  @override
  void dispose() {
    _homePageBloc.add(ResetFetchNotesEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NotePageBloc>(context);
    final signInBloc = BlocProvider.of<SignInPageBloc>(context);
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);

    Future<void> handleCardPress(String id) async {
      noteBloc.add(StartFetchNoteEvent(id: id));
      await Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: NotePage.ROUTE),
            builder: (context) => AuthGuardProvider(
              bloc: signInBloc,
              component: NotePageProvider(
                notePageBloc: noteBloc,
                signInPageBloc: signInBloc,
              ),
            ),
          ));
    }

    return BlocBuilder<HomePageBloc, HomePageState>(
      buildWhen: (pre, current) =>
          pre.fetchNotesStatus != FetchNotesStatus.failure ||
          current.fetchNotesStatus != FetchNotesStatus.failure,
      builder: (context, state) {
        Widget returnWidget;
        switch (state.fetchNotesStatus) {
          case FetchNotesStatus.initial:
            _homePageBloc.add(StartFetchNotesEvent());
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
