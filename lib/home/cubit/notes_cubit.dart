import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repositories.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit(this._noteRepository) : super(const NotesState());
  final NoteRepository _noteRepository;

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void resetFetchingNotes() {
    _notesSubscription?.cancel();
    emit(state.copyWith(
        fetchNotes: <Note>[], fetchNotesStatus: FetchNotesStatus.initial));
  }

  void successFetchNotes(List<Note> notes) {
    emit(state.copyWith(
        fetchNotesStatus: FetchNotesStatus.onProgress, fetchNotes: notes));
  }

  Future<void> fetchNotes() async {
    emit(state.copyWith(fetchNotesStatus: FetchNotesStatus.loading));
    try {
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository.getNotesStream().listen((event) {
        return successFetchNotes(
            event.docs.map((e) => Note.fromFirebase(e.id, e.data())).toList());
      });
    } catch (e) {
      return failFetchingNotes();
    }
  }

  void failFetchingNotes() {
    emit(state.copyWith(fetchNotesStatus: FetchNotesStatus.failure));
  }

  void resetAddingNote() {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.initial, addNote: null));
  }

  Future<void> addNote(Note note) async {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.loading));
    try {
      await _noteRepository.addNote(note);
      return successAddNote();
    } catch (e) {
      return failAddNote();
    }
  }

  void successAddNote() {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.succeeded));
  }

  void failAddNote() {
    emit(state.copyWith(addNoteStatus: AddNoteStatus.failure));
  }
}
