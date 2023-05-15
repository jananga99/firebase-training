import 'note.dart';

class FetchNotesResult {
  FetchNotesResult({
    required this.success,
    this.notes,
  });
  final bool success;
  final List<Note>? notes;
}
