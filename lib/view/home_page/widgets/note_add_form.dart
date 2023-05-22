import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/db/model/note.dart';
import 'package:project1/view/home_page/home_page_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';
import 'package:project1/widgets/custom/constants.dart';

class NoteAddForm extends StatefulWidget {
  const NoteAddForm({Key? key}) : super(key: key);

  @override
  State<NoteAddForm> createState() => _NoteAddFormState();
}

class _NoteAddFormState extends State<NoteAddForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleInputController = TextEditingController();
  final TextEditingController _descriptionInputController =
      TextEditingController();
  late HomePageBloc _homePageBloc;

  @override
  void dispose() {
    _descriptionInputController.dispose();
    _titleInputController.dispose();
    _homePageBloc.add(ResetAddNoteEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signInPageBloc = BlocProvider.of<SignInPageBloc>(context);
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);

    Future<void> handleSubmit() async {
      final String? email = signInPageBloc.state.user?.email;
      if (_formKey.currentState!.validate() && email != null) {
        _homePageBloc.add(AddNoteEvent(Note(
            title: _titleInputController.text,
            description: _descriptionInputController.text,
            email: email)));
      }
    }

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
                  controller: _titleInputController,
                  cursorColor: Theme.of(context).colorScheme.onBackground,
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextFormField(
                  maxLines: null,
                  minLines: 10,
                  controller: _descriptionInputController,
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
              Visibility(
                visible: true,
                child: Center(
                  child: SizedBox(
                    width: 480,
                    child: ElevatedButton(
                        onPressed: handleSubmit,
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              BlocBuilder<HomePageBloc, HomePageState>(
                buildWhen: (pre, current) =>
                    pre.addNoteStatus != current.addNoteStatus,
                builder: (context, state) {
                  return Column(
                    children: [
                      Visibility(
                        visible: state.addNoteStatus == AddNoteStatus.loading,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.addNoteStatus == AddNoteStatus.failure,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              Messages.addNoteFailed,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.addNoteStatus == AddNoteStatus.succeeded,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              Messages.addNoteSuccess,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          )),
    );
  }
}
