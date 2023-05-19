import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';
import 'package:project1/widgets/custom/custom_colors.dart';

import '../../../view/home_page/home_page_provider.dart';
import '../../../view/home_page/home_page_view.dart';
import '../../../view/sign_in_page/auth_guard_provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignOut() async {
      context.read<SignInPageBloc>().add(StartSignOutEvent());
      final signInPageBloc = SignInPageBloc();
      await Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: HomePage.ROUTE),
            builder: (context) => AuthGuardProvider(
              bloc: signInPageBloc,
              component: HomePageProvider(
                bloc: signInPageBloc,
              ),
            ),
          ));
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
