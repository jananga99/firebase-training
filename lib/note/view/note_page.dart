import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/note_repository/note_repository.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/header_bar/header_bar.dart';
import '../bloc/note_bloc.dart';
import '../widgets/note_card.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key, required NoteRepository noteRepository})
      : _noteRepository = noteRepository;

  final NoteRepository _noteRepository;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || (args as String).isEmpty) {
      Navigator.pushReplacementNamed(context, RouteConstants.homeRoute);
    }
    final id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: const HeaderBar(),
      backgroundColor: const Color(0xff00ffff),
      body: RepositoryProvider(
        create: (context) => _noteRepository,
        child: SingleChildScrollView(
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
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50),
                  child: BlocProvider(
                    create: (context) =>
                        NoteBloc(context.read<NoteRepository>())
                          ..add(NoteStarted(id: id)),
                    child: BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        Widget returnWidget;
                        switch (state.noteStatus) {
                          case NoteStatus.initial:
                            context.read<NoteBloc>().add(NoteStarted(id: id));
                            returnWidget = const Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            );
                            break;
                          case NoteStatus.loading:
                            returnWidget = const Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            );
                            break;
                          case NoteStatus.onProgress:
                            returnWidget = state.note == null
                                ? const SizedBox()
                                : NoteCard(state.note!);
                            break;
                          case NoteStatus.failure:
                            showMessage(context, Messages.getNoteFailed);
                            returnWidget = const SizedBox();
                            break;
                          default:
                            returnWidget = const SizedBox();
                        }
                        return returnWidget;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
