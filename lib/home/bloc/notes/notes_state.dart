part of 'notes_bloc.dart';

enum NoteStatus { initial, onProgress, failure }

class NoteState extends Equatable {
  const NoteState(
      {this.noteStatus = NoteStatus.initial, this.notes = const <Note>[]});

  final NoteStatus noteStatus;
  final List<Note> notes;

  NoteState copyWith({NoteStatus? noteStatus, List<Note>? notes}) {
    return NoteState(
        noteStatus: noteStatus ?? this.noteStatus, notes: notes ?? this.notes);
  }

  @override
  List<Object> get props => [noteStatus, notes];
}
