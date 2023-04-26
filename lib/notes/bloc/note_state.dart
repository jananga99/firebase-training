part of 'note_bloc.dart';

enum NoteStatus { initial, onProgress, failure }

abstract class NoteState extends Equatable {
  const NoteState(this.status, this.notes);

  final NoteStatus status;
  final List<Note> notes;

  @override
  List<Object> get props => [status, notes];
}

class NoteInitial extends NoteState {
  const NoteInitial() : super(NoteStatus.initial, const <Note>[]);
}

class NoteInProgress extends NoteState {
  const NoteInProgress(notes) : super(NoteStatus.onProgress, notes);
}

class NoteFail extends NoteState {
  const NoteFail() : super(NoteStatus.failure, const <Note>[]);
}
