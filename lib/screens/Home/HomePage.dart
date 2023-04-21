import 'package:flutter/material.dart';
import 'package:project1/services/auth.service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: handleSignOut, child: const Text("Sign out")),
          ],
        ),
        const Text("This will be the home page"),
      ],
    );
  }
}
