import 'note.dart';

class FetchNotesResponse {
  FetchNotesResponse({required this.notes});
  final List<Note> notes;
  factory FetchNotesResponse.fromJson(Map<String, dynamic> json) {
    return FetchNotesResponse(
      notes: List<Note>.from(json['notes'].map((e) => Note.fromJson(e))),
    );
  }
}
