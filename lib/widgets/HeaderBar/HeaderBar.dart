import 'package:flutter/material.dart';

import '../../services/auth.service.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const HeaderBar({Key? key})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        const Icon(Icons.notifications),
        Container(
          margin: const EdgeInsets.only(right: 30),
          child: DropdownButton<String>(
            icon: const Icon(Icons.person_2_rounded),
            onChanged: (String? value) {
              if (value == "sign-out") {
                handleSignOut();
              }
            },
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem<String>(
                value: "sign-out",
                child: Text("Sign Out"),
              )
            ],
          ),
        )
      ],
    );
  }
}
