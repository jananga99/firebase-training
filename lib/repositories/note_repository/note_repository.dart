import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'models/models.dart';

export 'models/models.dart';

class NoteRepository {
  final FirebaseFirestore _firebaseFirestore;
  final String _apiUrl;
  final String _pathUrl;
  final String _token;

  NoteRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _apiUrl = dotenv.env['API_URL']!,
        _pathUrl = dotenv.env['PATH_URL']!,
        _token = dotenv.env['TOKEN']!;

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
    return _firebaseFirestore
        .collection("notes1")
        .orderBy("createdAt")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getNoteStream(String id) {
    return _firebaseFirestore.collection("notes1").doc(id).snapshots();
  }

  Stream<FetchNotesResult> getNotesStreamMock() async* {
    final Uri uri = Uri.https(_apiUrl, _pathUrl, {
      'apidogToken': _token,
    });
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    while (true) {
      try {
        final http.Response response = await http.get(uri, headers: headers);
        final FetchNotesResponse res =
            FetchNotesResponse.fromJson(jsonDecode(response.body));
        yield FetchNotesResult(success: true, notes: res.notes);
      } catch (e) {
        yield FetchNotesResult(success: false);
      }
      await Future.delayed(const Duration(seconds: 2));
    }
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
