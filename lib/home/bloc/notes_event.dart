part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object> get props => [];
}

class FetchNotesReset extends NotesEvent {}

class FetchNotesStarted extends NotesEvent {}

class NotesFetched extends NotesEvent {
  final List<Note> notes;
  const NotesFetched({required this.notes});
}

class FetchNotesFailed extends NotesEvent {}

class AddNoteStarted extends NotesEvent {
  final Note note;
  const AddNoteStarted(this.note);
}

class AddNoteSucceeded extends NotesEvent {
  final Note note;
  const AddNoteSucceeded(this.note);
}

class AddNoteFailed extends NotesEvent {}

class AddNoteReset extends NotesEvent {}
