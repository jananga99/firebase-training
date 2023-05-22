import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note.dart';

class NoteRepository {
  NoteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firebaseFirestore;

  List<Note> fromQuerySnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((e) => Note.fromFirebase(e.id, e.data())).toList();
  }

  Note fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Note.fromFirebase(snapshot.id, snapshot.data()!);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> query() {
    return _firebaseFirestore
        .collection("notes1")
        .orderBy("createdAt")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> querySingle(String id) {
    return _firebaseFirestore.collection("notes1").doc(id).snapshots();
  }

  Future<DocumentReference> add(Note note) async {
    return await _firebaseFirestore.collection("notes1").add(note.toFirebase());
  }
}
