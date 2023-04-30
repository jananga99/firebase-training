import 'package:flutter/material.dart';

import '../../common/constants.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleHomeClick() {
      Navigator.of(context).pushReplacementNamed(RouteConstants.homeRoute);
    }

    return TextButton(
      onPressed: handleHomeClick,
      child: const Icon(
        Icons.home,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
