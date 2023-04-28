import 'package:flutter/material.dart';

import '../../services/note_service.dart';
import '../../utils/constants.dart';

class NoteAddForm extends StatefulWidget {
  const NoteAddForm({Key? key}) : super(key: key);

  @override
  State<NoteAddForm> createState() => _NoteAddFormState();
}

class _NoteAddFormState extends State<NoteAddForm> {
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

  @override
  void dispose() {
    descriptionInputController.dispose();
    titleInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
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
                visible: true,
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
                visible: true,
                child: SizedBox(
                  width: 480,
                  child: ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(fontSize: 20, color: Colors.black),
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
            ],
          )),
    );
  }
}
