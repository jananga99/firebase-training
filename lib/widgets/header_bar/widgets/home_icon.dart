import 'package:flutter/material.dart';

import '../../../common/constants.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleHomeClick() {
      Navigator.of(context).pushReplacementNamed(RouteConstants.homeRoute);
    }

    return TextButton(
      onPressed: handleHomeClick,
      child: Icon(
        Icons.home,
        color: Theme.of(context).colorScheme.onBackground,
        size: 30,
      ),
    );
  }
}
