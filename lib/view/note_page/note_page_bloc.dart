import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/db/model/note.dart';
import 'package:project1/db/repo/note_repository.dart';

part 'note_page_event.dart';
part 'note_page_state.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  NotePageBloc() : super(NotePageState.initialState) {
    on<FetchNoteEvent>(_onFetchNote);
    on<StartFetchNoteEvent>(_onStartFetchNote);
    on<ErrorFetchNoteEvent>(_onErrorFetchNote);
  }

  final NoteRepository _noteRepository = NoteRepository();

  StreamSubscription<dynamic>? _noteSubscription;

  @override
  Future<void> close() {
    _noteSubscription?.cancel();
    return super.close();
  }

  void _onFetchNote(
    FetchNoteEvent event,
    Emitter<NotePageState> emit,
  ) {
    emit(state.clone(noteStatus: FetchNoteStatus.onProgress, note: event.note));
  }

  Future<void> _onStartFetchNote(
      StartFetchNoteEvent event, Emitter<NotePageState> emit) async {
    emit(state.clone(noteStatus: FetchNoteStatus.loading, id: event.id));
    try {
      _noteSubscription?.cancel();
      _noteSubscription = _noteRepository.querySingle(event.id).listen((e) {
        return add(
            FetchNoteEvent(note: _noteRepository.fromDocumentSnapshot(e)));
      });
    } catch (e) {
      return add(ErrorFetchNoteEvent());
    }
  }

  void _onErrorFetchNote(
    ErrorFetchNoteEvent event,
    Emitter<NotePageState> emit,
  ) {
    emit(state.clone(noteStatus: FetchNoteStatus.failure));
  }
}
