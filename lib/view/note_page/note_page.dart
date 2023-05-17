import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/common/constants.dart';
import 'package:project1/view/note_page/note_card.dart';
import 'package:project1/view/note_page/note_page_bloc.dart';
import 'package:project1/widgets/header_bar/header_bar.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final notePageBloc = BlocProvider.of<NotePageBloc>(context);
    final String? stateId = notePageBloc.state.id;
    late String id;
    if (stateId == null || stateId.isEmpty) {
      Future(() {
        Navigator.pushReplacementNamed(context, RouteConstants.homeRoute);
      });
    } else {
      id = stateId;
    }
    return Scaffold(
      appBar: const HeaderBar(),
      backgroundColor: const Color(0xff00ffff),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Note Details",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: BlocBuilder<NotePageBloc, NotePageState>(
                  buildWhen: (pre, current) =>
                      pre.noteStatus != FetchNoteStatus.failure ||
                      current.noteStatus != FetchNoteStatus.failure,
                  builder: (context, state) {
                    Widget returnWidget;
                    switch (state.noteStatus) {
                      case FetchNoteStatus.initial:
                        returnWidget = Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                        break;
                      case FetchNoteStatus.loading:
                        returnWidget = Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                        break;
                      case FetchNoteStatus.onProgress:
                        returnWidget = state.note == null
                            ? const SizedBox()
                            : NoteCard(state.note!);
                        break;
                      case FetchNoteStatus.failure:
                        returnWidget = const Text(Messages.getNoteFailed);
                        break;
                      default:
                        returnWidget = const SizedBox();
                    }
                    return returnWidget;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
