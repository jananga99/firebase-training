import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/note_repository/models/note.dart';
import 'package:project1/repositories/note_repository/note_repository.dart';

part 'note_page_event.dart';
part 'note_page_state.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  NotePageBloc() : super(NotePageState.initialState) {
    on<FetchNoteEvent>(_onNoteFetched);
    on<StartFetchNoteEvent>(_onNoteStarted);
    on<ErrorFetchNoteEvent>(_onNoteFailed);
  }

  final NoteRepository _noteRepository = NoteRepository();

  StreamSubscription<dynamic>? _noteSubscription;

  @override
  Future<void> close() {
    _noteSubscription?.cancel();
    return super.close();
  }

  void _onNoteFetched(
    FetchNoteEvent event,
    Emitter<NotePageState> emit,
  ) {
    emit(state.clone(noteStatus: FetchNoteStatus.onProgress, note: event.note));
  }

  Future<void> _onNoteStarted(
      StartFetchNoteEvent event, Emitter<NotePageState> emit) async {
    emit(state.clone(noteStatus: FetchNoteStatus.loading, id: event.id));
    try {
      _noteSubscription?.cancel();
      _noteSubscription = _noteRepository.getNoteStream(event.id).listen((e) {
        return add(
            FetchNoteEvent(note: Note.fromFirebase(event.id, e.data()!)));
      });
    } catch (e) {
      return add(ErrorFetchNoteEvent());
    }
  }

  void _onNoteFailed(
    ErrorFetchNoteEvent event,
    Emitter<NotePageState> emit,
  ) {
    emit(state.clone(noteStatus: FetchNoteStatus.failure));
  }
}
