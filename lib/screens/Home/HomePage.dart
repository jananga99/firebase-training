import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/services/auth.service.dart';
import 'package:project1/services/note.service.dart';
import 'package:project1/utils/constants.dart';
import 'package:project1/widgets/NoteCard/NoteCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleInputController = TextEditingController();
  TextEditingController descriptionInputController = TextEditingController();

  void showMessage(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> handleSignOut() async {
    final res = await signOut();
    if (res.runtimeType == String) {
      showMessage(res);
    }
  }

  Future<void> handleSubmit() async {
    setState(() {
      isAddLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final res = await addNote(
          title: titleInputController.text,
          description: descriptionInputController.text);
      showMessage(res);
      if (res == Messages.addNoteSuccess) {
        titleInputController.clear();
        descriptionInputController.clear();
      }
    }
    setState(() {
      isAddLoading = false;
    });
  }

  bool isAddLoading = false;

  void handleCardPress(String id) {
    Navigator.pushNamed(context, RouteConstants.noteViewRoute, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: handleSignOut, child: const Text("Sign out")),
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  "Home",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  "You are here. Homw",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleInputController,
                        decoration: InputDecoration(
                          hintText: 'Submit New',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionInputController,
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                          onPressed: handleSubmit,
                          child: const Text(
                            "SUBMIT",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: isAddLoading
                            ? const CircularProgressIndicator(
                                color: Colors.red,
                              )
                            : const SizedBox(),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: getNotesStream(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            showMessage(Messages.getNotesFailed);
                            return const SizedBox();
                          }

                          if (snapshot.connectionState ==
                                  ConnectionState.waiting &&
                              snapshot.data == null) {
                            return const CircularProgressIndicator(
                              color: Colors.green,
                            );
                          }

                          if (isAddLoading) {
                            return const SizedBox();
                          }

                          return ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return TextButton(
                                    onPressed: () {
                                      handleCardPress(document.id);
                                    },
                                    child: NoteCard(
                                        id: document.id,
                                        title: data['title'],
                                        description: data['description'],
                                        email: data['email']),
                                  );
                                })
                                .toList()
                                .cast(),
                          );
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
