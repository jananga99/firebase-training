import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/note_repository/models/note.dart';
import 'package:project1/repositories/note_repository/note_repository.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageState.initialState) {
    on<FetchNotesEvent>(_onNotesFetched);
    on<StartFetchNotesEvent>(_onNotesStarted);
    on<ErrorFetchNotesEvent>(_onNotesFailed);
    on<AddNoteEvent>(_onAddNoteStarted);
    on<SuccessAddNoteEvent>(_onAddNoteSucceeded);
    on<ErrorAddNoteEvent>(_onAddNoteFailed);
    on<ResetFetchNotesEvent>(_onFetchNotesReset);
    on<ResetAddNoteEvent>(_onAddNoteReset);
  }

  final NoteRepository _noteRepository = NoteRepository();

  StreamSubscription<dynamic>? _notesSubscription;

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _onFetchNotesReset(
      ResetFetchNotesEvent event, Emitter<HomePageState> emit) {
    _notesSubscription?.cancel();
    emit(state.clone(
        fetchNotes: <Note>[], fetchNotesStatus: FetchNotesStatus.initial));
  }

  void _onNotesFetched(
    FetchNotesEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(state.clone(
        fetchNotesStatus: FetchNotesStatus.onProgress,
        fetchNotes: event.notes));
  }

  Future<void> _onNotesStarted(
      StartFetchNotesEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(fetchNotesStatus: FetchNotesStatus.loading));
    try {
      _notesSubscription?.cancel();
      _notesSubscription = _noteRepository.getNotesStream().listen((event) {
        return add(FetchNotesEvent(
            notes: event.docs
                .map((e) => Note.fromFirebase(e.id, e.data()))
                .toList()));
      });
    } catch (e) {
      return add(ErrorFetchNotesEvent());
    }
  }

  void _onNotesFailed(
    ErrorFetchNotesEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(state.clone(fetchNotesStatus: FetchNotesStatus.failure));
  }

  void _onAddNoteReset(ResetAddNoteEvent event, Emitter<HomePageState> emit) {
    emit(state.clone(addNoteStatus: AddNoteStatus.initial, addNote: null));
  }

  Future<void> _onAddNoteStarted(
      AddNoteEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(addNoteStatus: AddNoteStatus.loading));
    try {
      final Note? note = await _noteRepository.addNote(event.note);
      return add(SuccessAddNoteEvent(note!));
    } catch (e) {
      return add(ErrorAddNoteEvent());
    }
  }

  void _onAddNoteSucceeded(
      SuccessAddNoteEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(addNoteStatus: AddNoteStatus.succeeded));
  }

  void _onAddNoteFailed(
      ErrorAddNoteEvent event, Emitter<HomePageState> emit) async {
    emit(state.clone(addNoteStatus: AddNoteStatus.failure));
  }
}
