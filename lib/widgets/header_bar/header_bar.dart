import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/battery_service.dart';
import '../../utils/constants.dart';

class HeaderBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const HeaderBar({Key? key})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  int _batteryLevel = -1;

  Future<void> setBatteryPercentage() async {
    final result = await getBatteryPercentage();
    setState(() {
      _batteryLevel = result;
    });
  }

  @override
  void initState() {
    super.initState();
    setBatteryPercentage();
  }

  @override
  Widget build(BuildContext context) {
    void showMessage(message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }

    void handleHomeClick() {
      Navigator.pushNamed(context, RouteConstants.homeRoute);
    }

    Future<void> handleSignOut() async {
      final res = await signOut();
      if (res.runtimeType == String) {
        showMessage(res);
      }
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xff00ffff),
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 40),
          child: TextButton(
            onPressed: handleHomeClick,
            child: const Icon(
              Icons.home,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        const Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          size: 30,
        ),
        Container(
          margin: const EdgeInsets.only(right: 30),
          child: DropdownButton<String>(
            icon: const CircleAvatar(
                backgroundColor: Colors.deepPurple,
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
          ),
        ),
        _batteryLevel >= -1
            ? Container(
                margin: const EdgeInsets.only(right: 30),
                child: Row(
                  children: [
                    Text(
                      _batteryLevel >= 0 ? "$_batteryLevel%" : "??%",
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    const Icon(
                      Icons.battery_full,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
