part of 'note_bloc.dart';

enum NoteStatus { initial, loading, onProgress, failure }

class NoteState extends Equatable {
  const NoteState({this.noteStatus = NoteStatus.initial, this.note, this.id});

  final String? id;
  final NoteStatus noteStatus;
  final Note? note;

  NoteState copyWith({NoteStatus? noteStatus, Note? note, String? id}) {
    return NoteState(
        noteStatus: noteStatus ?? this.noteStatus,
        note: note ?? this.note,
        id: id ?? this.id);
  }

  @override
  List<dynamic> get props => [NoteStatus, note, id];
}
