import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(this._noteRepository) : super(const NotesState()) {
    on<NotesFetched>(_onNotesFetched);
    on<FetchNotesStarted>(_onNotesStarted);
    on<FetchNotesFailed>(_onNotesFailed);
    on<AddNoteStarted>(_onAddNoteStarted);
    on<AddNoteSucceeded>(_onAddNoteSucceeded);
    on<AddNoteFailed>(_onAddNoteFailed);
    on<FetchNotesReset>(_onFetchNotesReset);
    on<AddNoteReset>(_onAddNoteReset);
  }

  final NoteRepository _noteRepository;

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _onFetchNotesReset(FetchNotesReset event, Emitter<NotesState> emit) {
    _notesSubscription?.cancel();
    emit(state.copyWith(
        fetchNotes: <Note>[], fetchNotesStatus: FetchNotesStatus.initial));
  }

  void _onNotesFetched(
    NotesFetched event,
    Emitter<NotesState> emit,
  ) {
    emit(state.copyWith(
        fetchNotesStatus: FetchNotesStatus.onProgress,
        fetchNotes: event.notes));
  }

  Future<void> _onNotesStarted(
      FetchNotesStarted event, Emitter<NotesState> emit) async {
    emit(state.copyWith(fetchNotesStatus: FetchNotesStatus.loading));
    try {
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository.getNotesStream().listen((event) {
        return add(NotesFetched(
            notes: event.docs
                .map((e) => Note.fromFirebase(e.id, e.data()))
                .toList()));
      });
    } catch (e) {
      return add(FetchNotesFailed());
    }
  }

  void _onNotesFailed(
    FetchNotesFailed event,
    Emitter<NotesState> emit,
  ) {
    emit(state.copyWith(fetchNotesStatus: FetchNotesStatus.failure));
  }

  void _onAddNoteReset(AddNoteReset event, Emitter<NotesState> emit) {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.initial, addNote: null));
  }

  Future<void> _onAddNoteStarted(
      AddNoteStarted event, Emitter<NotesState> emit) async {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.loading));
    try {
      final Note? note = await _noteRepository.addNote(event.note);
      return add(AddNoteSucceeded(note!));
    } catch (e) {
      return add(AddNoteFailed());
    }
  }

  void _onAddNoteSucceeded(
      AddNoteSucceeded event, Emitter<NotesState> emit) async {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.succeeded));
  }

  void _onAddNoteFailed(AddNoteFailed event, Emitter<NotesState> emit) async {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.failure));
  }
}
