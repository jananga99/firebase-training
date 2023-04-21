import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  final String title;
  final String description;
  final String email;

  const NoteCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.email})
      : super(key: key);

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
      color: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: [
        ListTile(
          title: Text(widget.title),
          subtitle: Text(widget.email),
        ),
        Text(getDescription(widget.description)),
        TextButton(
            onPressed: toggleShowMore,
            child: Text(getShowMoreText(widget.description)))
      ]),
    );
  }
}
