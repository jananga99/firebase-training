import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../sign_in/sign_in.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignOut() async {
      context.read<AuthCubit>().signOut();
    }

    return DropdownButton<String>(
      icon: CircleAvatar(
          backgroundColor: Theme.of(context).iconTheme.color,
          radius: 15,
          child: const Icon(Icons.person_2_rounded)),
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
    );
  }
}
