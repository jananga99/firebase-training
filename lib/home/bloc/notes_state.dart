part of 'notes_bloc.dart';

enum NotesStatus { initial, loading, onProgress, failure }

class NotesState extends Equatable {
  const NotesState(
      {this.noteStatus = NotesStatus.initial, this.notes = const <Note>[]});

  final NotesStatus noteStatus;
  final List<Note> notes;

  NotesState copyWith({NotesStatus? noteStatus, List<Note>? notes}) {
    return NotesState(
        noteStatus: noteStatus ?? this.noteStatus, notes: notes ?? this.notes);
  }

  @override
  List<Object> get props => [noteStatus, notes];
}
