part of 'home_page_bloc.dart';

abstract class HomePageEvent {}

class ResetFetchNotesEvent extends HomePageEvent {}

class StartFetchNotesEvent extends HomePageEvent {}

class FetchNotesEvent extends HomePageEvent {
  final List<Note> notes;
  FetchNotesEvent({required this.notes});
}

class ErrorFetchNotesEvent extends HomePageEvent {}

class AddNoteEvent extends HomePageEvent {
  final Note note;
  AddNoteEvent(this.note);
}

class SuccessAddNoteEvent extends HomePageEvent {
  final Note note;
  SuccessAddNoteEvent(this.note);
}

class ErrorAddNoteEvent extends HomePageEvent {}

class ResetAddNoteEvent extends HomePageEvent {}
