import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/note.dart';
import '../../services/note_service.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc() : super(const NoteInitial()) {
    on<NoteFetched>(_onNoteFetched);
    on<NoteStarted>(_onNoteStarted);
    on<NoteFailed>(_onNoteFailed);
  }

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _onNoteFetched(
    NoteFetched event,
    Emitter<NoteState> emit,
  ) {
    emit(NoteInProgress(event.notes));
  }

  Future<void> _onNoteStarted(
      NoteStarted event, Emitter<NoteState> emit) async {
    emit(const NoteInProgress(<Note>[]));
    try {
      _notesSubscription = getNotesStream().listen((event) {
        return add(NoteFetched(
            notes: event.docs
                .map((e) => Note.fromFirebase(e.id, e.data()))
                .toList()));
      });
    } catch (e) {
      return add(NoteFailed());
    }
  }

  void _onNoteFailed(
    NoteFailed event,
    Emitter<NoteState> emit,
  ) {
    emit(const NoteFail());
  }
}
