import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/repositories.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc(this._noteRepository) : super(const NoteState()) {
    on<NoteFetched>(_onNoteFetched);
    on<NoteStarted>(_onNoteStarted);
    on<NoteFailed>(_onNoteFailed);
  }

  final NoteRepository _noteRepository;

  StreamSubscription<dynamic>? _noteSubscription;

  @override
  Future<void> close() {
    _noteSubscription?.cancel();
    return super.close();
  }

  void _onNoteFetched(
    NoteFetched event,
    Emitter<NoteState> emit,
  ) {
    emit(state.copyWith(noteStatus: NoteStatus.onProgress, note: event.note));
  }

  Future<void> _onNoteStarted(
      NoteStarted event, Emitter<NoteState> emit) async {
    emit(state.copyWith(noteStatus: NoteStatus.loading));
    try {
      _noteSubscription?.cancel();
      _noteSubscription = _noteRepository.getNoteStream(event.id).listen((e) {
        return add(NoteFetched(note: Note.fromFirebase(event.id, e.data()!)));
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
