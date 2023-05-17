part of 'note_page_bloc.dart';

enum FetchNoteStatus { initial, loading, onProgress, failure }

class NotePageState {
  const NotePageState(
      {required this.noteStatus, required this.note, required this.id});

  final String? id;
  final FetchNoteStatus noteStatus;
  final Note? note;

  static NotePageState get initialState => const NotePageState(
      noteStatus: FetchNoteStatus.initial, note: null, id: null);

  NotePageState clone({FetchNoteStatus? noteStatus, Note? note, String? id}) {
    return NotePageState(
        noteStatus: noteStatus ?? this.noteStatus,
        note: note ?? this.note,
        id: id ?? this.id);
  }
}
