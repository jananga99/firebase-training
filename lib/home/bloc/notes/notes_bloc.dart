import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/repositories.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(this._noteRepository) : super(const NoteState()) {
    on<NoteFetched>(_onNoteFetched);
    on<NoteStarted>(_onNoteStarted);
    on<NoteFailed>(_onNoteFailed);
  }

  final NoteRepository _noteRepository;

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
    emit(state.copyWith(noteStatus: NoteStatus.onProgress, notes: event.notes));
  }

  Future<void> _onNoteStarted(
      NoteStarted event, Emitter<NoteState> emit) async {
    emit(state.copyWith(noteStatus: NoteStatus.onProgress, notes: <Note>[]));
    try {
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository.getNotesStream().listen((event) {
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
    emit(state.copyWith(noteStatus: NoteStatus.failure));
  }
}
