import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';
import 'package:project1/widgets/custom/custom_colors.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignOut() async {
      context.read<SignInPageBloc>().add(StartSignOutEvent());
    }

    return DropdownButton<String>(
      icon: const CircleAvatar(
          backgroundColor: CustomColors.ICON_BACKGROUND,
          radius: 15,
          child: Icon(Icons.person_2_rounded)),
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
