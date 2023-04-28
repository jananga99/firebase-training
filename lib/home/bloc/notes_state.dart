part of 'notes_bloc.dart';

enum NotesStatus { initial, loading, onProgress, failure }

class NotesState extends Equatable {
  const NotesState(
      {this.notesStatus = NotesStatus.initial, this.notes = const <Note>[]});

  final NotesStatus notesStatus;
  final List<Note> notes;

  NotesState copyWith({NotesStatus? notesStatus, List<Note>? notes}) {
    return NotesState(
        notesStatus: notesStatus ?? this.notesStatus,
        notes: notes ?? this.notes);
  }

  @override
  List<Object> get props => [notesStatus, notes];
}
