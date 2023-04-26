part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
  @override
  List<Object> get props => [];
}

class NoteStarted extends NoteEvent {}

class NoteFetched extends NoteEvent {
  final List<Note> notes;
  const NoteFetched({required this.notes});
}

class NoteFailed extends NoteEvent {}
