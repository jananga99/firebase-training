part of 'notes_cubit.dart';

enum FetchNotesStatus { initial, loading, onProgress, failure }

enum AddNoteStatus { initial, loading, succeeded, failure }

class NotesState extends Equatable {
  const NotesState(
      {this.fetchNotesStatus = FetchNotesStatus.initial,
      this.fetchNotes = const <Note>[],
      this.addNoteStatus = AddNoteStatus.initial,
      this.addNote});

  final FetchNotesStatus fetchNotesStatus;
  final List<Note> fetchNotes;
  final AddNoteStatus addNoteStatus;
  final Note? addNote;

  NotesState copyWith(
      {FetchNotesStatus? fetchNotesStatus,
      List<Note>? fetchNotes,
      AddNoteStatus? addNoteStatus,
      Note? addNote}) {
    return NotesState(
        fetchNotesStatus: fetchNotesStatus ?? this.fetchNotesStatus,
        fetchNotes: fetchNotes ?? this.fetchNotes,
        addNoteStatus: addNoteStatus ?? this.addNoteStatus,
        addNote: addNote ?? this.addNote);
  }

  @override
  List<dynamic> get props =>
      [fetchNotesStatus, fetchNotes, addNote, addNoteStatus];
}
