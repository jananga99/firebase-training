import 'package:flutter/material.dart';

import '../../models/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard(this.note, {Key? key}) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool showMore = false;

  void toggleShowMore() {
    setState(() {
      showMore = !showMore;
    });
  }

  String getDescription(String description) {
    return showMore || description.length <= 100
        ? description
        : '${description.substring(0, 100)}...';
  }

  String getShowMoreText(String description) {
    if (description.length <= 100) {
      return "";
    } else {
      return showMore ? "SHOW LESS" : "SHOW MORE";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffccffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.note.title,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          subtitle: Text(
            widget.note.email,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  getDescription(widget.note.description),
                  softWrap: false,
                  maxLines: 1000,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: toggleShowMore,
                  child: Text(getShowMoreText(widget.note.description),
                      style: const TextStyle(color: Colors.black))),
            ],
          ),
        )
      ]),
    );
  }
}
