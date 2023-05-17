part of 'home_page_bloc.dart';

enum FetchNotesStatus { initial, loading, onProgress, failure }

enum AddNoteStatus { initial, loading, succeeded, failure }

class HomePageState {
  const HomePageState(
      {required this.fetchNotesStatus,
      required this.fetchNotes,
      required this.addNoteStatus,
      required this.addNote});

  final FetchNotesStatus fetchNotesStatus;
  final List<Note> fetchNotes;
  final AddNoteStatus addNoteStatus;
  final Note? addNote;

  static HomePageState get initialState => const HomePageState(
      fetchNotesStatus: FetchNotesStatus.initial,
      fetchNotes: <Note>[],
      addNoteStatus: AddNoteStatus.initial,
      addNote: null);

  HomePageState clone(
      {FetchNotesStatus? fetchNotesStatus,
      List<Note>? fetchNotes,
      AddNoteStatus? addNoteStatus,
      Note? addNote}) {
    return HomePageState(
        fetchNotesStatus: fetchNotesStatus ?? this.fetchNotesStatus,
        fetchNotes: fetchNotes ?? this.fetchNotes,
        addNoteStatus: addNoteStatus ?? this.addNoteStatus,
        addNote: addNote ?? this.addNote);
  }
}
