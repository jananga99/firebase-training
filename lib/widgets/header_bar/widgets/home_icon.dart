import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/view/home_page/home_page_provider.dart';
import 'package:project1/view/sign_in_page/auth_guard_provider.dart';
import 'package:project1/view/sign_in_page/sign_in_page_bloc.dart';

import '../../../view/home_page/home_page_view.dart';

class HomeIcon extends StatelessWidget {
  const HomeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signInPageBloc = BlocProvider.of<SignInPageBloc>(context);
    Future<void> handleHomeClick() async {
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
