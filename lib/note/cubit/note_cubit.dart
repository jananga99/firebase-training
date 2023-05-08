import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project1/repositories/repositories.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit(this._noteRepository) : super(const NoteState());
  final NoteRepository _noteRepository;

  StreamSubscription<dynamic>? _noteSubscription;
  @override
  Future<void> close() {
    _noteSubscription?.cancel();
    return super.close();
  }

  void successFetchNote(Note note) {
    emit(state.copyWith(noteStatus: NoteStatus.onProgress, note: note));
  }

  Future<void> fetchNote(String id) async {
    emit(state.copyWith(noteStatus: NoteStatus.loading, id: id));
    try {
      _noteSubscription?.cancel();
      _noteSubscription = _noteRepository.getNoteStream(id).listen((e) {
        return successFetchNote(Note.fromFirebase(id, e.data()!));
      });
    } catch (e) {
      return failFetchNote();
    }
  }

  void failFetchNote() {
    emit(state.copyWith(noteStatus: NoteStatus.failure));
  }
}
