import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/Note.dart';

import '../utils/constants.dart';
import 'auth.service.dart';

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
      await FirebaseFirestore.instance.collection("notes").add(note.toMap());
      message = Messages.addNoteSuccess;
    } catch (e) {
      message = Messages.addNoteFailed;
    }
  } else {
    message = Messages.addNoteFailed;
  }
  return message;
}

Stream<QuerySnapshot<dynamic>> getNotesStream() {
  return FirebaseFirestore.instance
      .collection("notes")
      .orderBy("createdAt")
      .snapshots();
}
