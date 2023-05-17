import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/note.dart';

class NoteRepository {
  NoteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
    return _firebaseFirestore
        .collection("notes1")
        .orderBy("createdAt")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getNoteStream(String id) {
    return _firebaseFirestore.collection("notes1").doc(id).snapshots();
  }

  Future<Note?> addNote(Note note) async {
    try {
      final DocumentReference<Map<String, dynamic>> docRef =
          await _firebaseFirestore.collection("notes1").add(note.toFirebase());
      return note.copyWith(id: docRef.id);
    } catch (e) {
      return null;
    }
  }
}
