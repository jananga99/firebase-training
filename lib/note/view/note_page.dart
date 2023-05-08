import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../header_bar/header_bar.dart';
import '../cubit/note_cubit.dart';
import '../widgets/note_card.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late String id;

  @override
  void initState() {
    super.initState();
    final String? stateId = context.read<NoteCubit>().state.id;
    if (stateId == null || stateId.isEmpty) {
      Future(() {
        Navigator.pushReplacementNamed(context, RouteConstants.homeRoute);
      });
    } else {
      id = stateId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(),
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
                child: BlocBuilder<NoteCubit, NoteState>(
                  buildWhen: (prev, state) =>
                      prev.noteStatus != NoteStatus.failure ||
                      state.noteStatus != NoteStatus.failure,
                  builder: (context, state) {
                    Widget returnWidget;
                    switch (state.noteStatus) {
                      case NoteStatus.initial:
                        returnWidget = Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                        break;
                      case NoteStatus.loading:
                        returnWidget = Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        );
                        break;
                      case NoteStatus.onProgress:
                        returnWidget = state.note == null
                            ? const SizedBox()
                            : NoteCard(state.note!);
                        break;
                      case NoteStatus.failure:
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
