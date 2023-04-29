import 'package:cloud_firestore/cloud_firestore.dart';

export 'models/note.dart';

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

  Future<String?> addNote(note) async {
    try {
      final docRef =
          await _firebaseFirestore.collection("notes").add(note.toFirebase());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }
}
