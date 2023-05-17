import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.notifications_outlined,
      color: Theme.of(context).colorScheme.onBackground,
      size: 30,
    );
  }
}
