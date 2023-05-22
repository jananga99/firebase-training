part of 'note_page_bloc.dart';

abstract class NotePageEvent {}

class StartFetchNoteEvent extends NotePageEvent {
  final String id;
  StartFetchNoteEvent({required this.id});
}

class FetchNoteEvent extends NotePageEvent {
  final Note note;
  FetchNoteEvent({required this.note});
}

class ErrorFetchNoteEvent extends NotePageEvent {}
