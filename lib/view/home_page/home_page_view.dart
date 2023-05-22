import 'package:flutter/material.dart';
import 'package:project1/view/home_page/widgets/note_add_form.dart';
import 'package:project1/view/home_page/widgets/notes_view.dart';
import 'package:project1/widgets/header_bar/header_bar.dart';

class HomePage extends StatelessWidget {
  static const String ROUTE = 'home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Home",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 25,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "You are here: Home",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  )),
              const NoteAddForm(),
              const NotesView()
            ],
          ),
        ),
      ),
    );
  }
}
