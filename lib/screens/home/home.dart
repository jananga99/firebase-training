import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/note.dart';
import '../../services/note_service.dart';
import '../../utils/constants.dart';
import '../../widgets/header_bar/header_bar.dart';
import '../../widgets/note_card/note_card.dart';

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
  bool showCompleteForm = false;

  void handleCardPress(String id) {
    Navigator.pushNamed(context, RouteConstants.noteViewRoute, arguments: id);
  }

  void showFullForm() {
    if (!showCompleteForm) {
      setState(() {
        showCompleteForm = true;
      });
    }
  }

  void hideFullForm() {
    if (showCompleteForm &&
        titleInputController.text.isEmpty &&
        descriptionInputController.text.isEmpty) {
      setState(() {
        showCompleteForm = false;
      });
    }
  }

  @override
  void dispose() {
    descriptionInputController.dispose();
    titleInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      backgroundColor: const Color(0xff00ffff),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: hideFullForm,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "Home",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "You are here: Home",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: showCompleteForm ? null : 200,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              onTap: showFullForm,
                              controller: titleInputController,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                filled: true,
                                fillColor: const Color(0xff4284f5),
                                hintText: 'Submit New',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color(0xff4284f5),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color(0xff4284f5),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the title';
                                }
                                return null;
                              },
                            ),
                          ),
                          Visibility(
                            visible: showCompleteForm,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                maxLines: null,
                                minLines: 10,
                                controller: descriptionInputController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xff4284f5),
                                  hintText: 'Enter Description',
                                  contentPadding: const EdgeInsets.all(20),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xff4284f5),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Color(0xff4284f5),
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the description';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: showCompleteForm,
                            child: SizedBox(
                              width: 480,
                              child: ElevatedButton(
                                  onPressed: handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "SUBMIT",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isAddLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.red,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
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
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                );
                              }

                              if (isAddLoading) {
                                return const SizedBox();
                              }

                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                      Note note = Note.fromFirebase(document
                                          .data()! as Map<String, dynamic>);
                                      return TextButton(
                                        onPressed: () {
                                          handleCardPress(document.id);
                                        },
                                        child: NoteCard(
                                            id: document.id,
                                            title: note.title,
                                            description: note.description,
                                            email: note.email),
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
        ),
      ),
    );
  }
}
