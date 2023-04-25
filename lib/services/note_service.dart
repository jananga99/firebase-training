import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';
import '../utils/constants.dart';
import 'auth_service.dart';

Future<String> addNote(
    {required String title, required String description}) async {
  final email = getCurrentUser()?.email;
  late String message;
  if (email != null) {
    final note = Note(
        title: title,
        description: description,
        email: email,
        createdAt: DateTime.now());
    try {
      await FirebaseFirestore.instance
          .collection("notes")
          .add(note.toFirebase());
      message = Messages.addNoteSuccess;
    } catch (e) {
      message = Messages.addNoteFailed;
    }
  } else {
    message = Messages.addNoteFailed;
  }
  return message;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
  return FirebaseFirestore.instance
      .collection("notes")
      .orderBy("createdAt")
      .snapshots();
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getNoteStream(String id) {
  return FirebaseFirestore.instance.collection("notes").doc(id).snapshots();
}
