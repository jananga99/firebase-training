part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();
  @override
  List<Object> get props => [];
}

class NoteStarted extends NoteEvent {
  final String id;
  const NoteStarted({required this.id});
}

class NoteFetched extends NoteEvent {
  final Note note;
  const NoteFetched({required this.note});
}

class NoteFailed extends NoteEvent {}
