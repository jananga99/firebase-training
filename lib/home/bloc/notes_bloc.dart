import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(this._noteRepository) : super(const NotesState()) {
    on<NotesFetched>(_onNoteFetched);
    on<NotesStarted>(_onNoteStarted);
    on<NotesFailed>(_onNoteFailed);
  }

  final NoteRepository _noteRepository;

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _onNoteFetched(
    NotesFetched event,
    Emitter<NotesState> emit,
  ) {
    emit(
        state.copyWith(noteStatus: NotesStatus.onProgress, notes: event.notes));
  }

  Future<void> _onNoteStarted(
      NotesStarted event, Emitter<NotesState> emit) async {
    emit(state.copyWith(noteStatus: NotesStatus.loading));
    try {
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository.getNotesStream().listen((event) {
        return add(NotesFetched(
            notes: event.docs
                .map((e) => Note.fromFirebase(e.id, e.data()))
                .toList()));
      });
    } catch (e) {
      return add(NotesFailed());
    }
  }

  void _onNoteFailed(
    NotesFailed event,
    Emitter<NotesState> emit,
  ) {
    emit(state.copyWith(noteStatus: NotesStatus.failure));
  }
}
