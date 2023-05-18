import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/db/model/note.dart';
import 'package:project1/db/repo/note_repository.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageState.initialState) {
    on<FetchNotesEvent>(_onFetchNotes);
    on<StartFetchNotesEvent>(_onStartFetchNotes);
    on<ErrorFetchNotesEvent>(_onErrorFetchNotes);
    on<AddNoteEvent>(_onAddNote);
    on<SuccessAddNoteEvent>(_onSuccessAddNote);
    on<ErrorAddNoteEvent>(_onErrorAddNote);
    on<ResetFetchNotesEvent>(_onRestFetchNotes);
    on<ResetAddNoteEvent>(_onResetAddNote);
  }

  final NoteRepository _noteRepository = NoteRepository();

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _onRestFetchNotes(
      ResetFetchNotesEvent event, Emitter<HomePageState> emit) {
    _notesSubscription?.cancel();
    emit(state.clone(
        fetchNotes: <Note>[], fetchNotesStatus: FetchNotesStatus.initial));
  }

  void _onFetchNotes(
    FetchNotesEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(state.clone(
        fetchNotesStatus: FetchNotesStatus.onProgress,
        fetchNotes: event.notes));
  }

  Future<void> _onStartFetchNotes(
      StartFetchNotesEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(fetchNotesStatus: FetchNotesStatus.loading));
    try {
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository.query().listen((e) {
        return add(
            FetchNotesEvent(notes: _noteRepository.fromQuerySnapshot(e)));
      });
    } catch (e) {
      return add(ErrorFetchNotesEvent());
    }
  }

  void _onErrorFetchNotes(
    ErrorFetchNotesEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(state.clone(fetchNotesStatus: FetchNotesStatus.failure));
  }

  void _onResetAddNote(ResetAddNoteEvent event, Emitter<HomePageState> emit) {
    emit(state.clone(addNoteStatus: AddNoteStatus.initial, addNote: null));
  }

  Future<void> _onAddNote(
      AddNoteEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(addNoteStatus: AddNoteStatus.loading));
    try {
      await _noteRepository.add(event.note);
      return add(SuccessAddNoteEvent());
    } catch (e) {
      return add(ErrorAddNoteEvent());
    }
  }

  void _onSuccessAddNote(
      SuccessAddNoteEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(addNoteStatus: AddNoteStatus.succeeded));
  }

  void _onErrorAddNote(
      ErrorAddNoteEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(addNoteStatus: AddNoteStatus.failure));
  }
}
