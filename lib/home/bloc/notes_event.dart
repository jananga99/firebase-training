part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object> get props => [];
}

class NotesStarted extends NotesEvent {}

class NotesFetched extends NotesEvent {
  final List<Note> notes;
  const NotesFetched({required this.notes});
}

class NotesFailed extends NotesEvent {}
