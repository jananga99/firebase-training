import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/services/note.service.dart';
import 'package:project1/widgets/NoteCard/NoteCard.dart';

import '../../utils/constants.dart';
import '../../widgets/HeaderBar/HeaderBar.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || (args as String).isEmpty) {
      Navigator.pop(context);
    }
    final id = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: const HeaderBar(),
      backgroundColor: const Color(0xff00ffff),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Note Details",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50),
              child: StreamBuilder(
                stream: getNoteStream(id),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    showMessage(Messages.getNoteFailed);
                    return const SizedBox();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Colors.green,
                    );
                  }

                  if (snapshot.data == null || snapshot.data!.data() == null) {
                    showMessage(Messages.getNoteFailed);
                    return const SizedBox();
                  }

                  final data = snapshot.data!.data();
                  final title = data!['title'];
                  final description = data['description'];
                  final email = data['email'];

                  return NoteCard(
                      title: title,
                      description: description,
                      email: email,
                      id: id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
