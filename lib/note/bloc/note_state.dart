part of 'note_bloc.dart';

enum NoteStatus { initial, loading, onProgress, failure }

class NoteState extends Equatable {
  const NoteState({this.noteStatus = NoteStatus.initial, this.note});

  final NoteStatus noteStatus;
  final Note? note;

  NoteState copyWith({NoteStatus? noteStatus, Note? note}) {
    return NoteState(
        noteStatus: noteStatus ?? this.noteStatus, note: note ?? this.note);
  }

  @override
  List<Object> get props => [NoteStatus, note.toString()];
}
