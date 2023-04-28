import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class NoteRepository {
  NoteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firebaseFirestore;

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
    return _firebaseFirestore
        .collection("notes")
        .orderBy("createdAt")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getNoteStream(String id) {
    return _firebaseFirestore.collection("notes").doc(id).snapshots();
  }

  Future<String?> addNote(
      {required String title,
      required String description,
      required String email}) async {
    final note = Note(
        title: title,
        description: description,
        email: email,
        createdAt: DateTime.now());
    try {
      final docRef =
          await _firebaseFirestore.collection("notes").add(note.toFirebase());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }
}
