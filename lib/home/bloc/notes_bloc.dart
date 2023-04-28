import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(this._noteRepository) : super(const NotesState()) {
    on<NotesFetched>(_onNotesFetched);
    on<NotesStarted>(_onNotesStarted);
    on<NotesFailed>(_onNotesFailed);
  }

  final NoteRepository _noteRepository;

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _onNotesFetched(
    NotesFetched event,
    Emitter<NotesState> emit,
  ) {
    emit(state.copyWith(
        notesStatus: NotesStatus.onProgress, notes: event.notes));
  }

  Future<void> _onNotesStarted(
      NotesStarted event, Emitter<NotesState> emit) async {
    emit(state.copyWith(notesStatus: NotesStatus.loading));
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

  void _onNotesFailed(
    NotesFailed event,
    Emitter<NotesState> emit,
  ) {
    emit(state.copyWith(notesStatus: NotesStatus.failure));
  }
}
