import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/db/repo/battery_repository.dart';
import 'package:project1/widgets/header_bar/header_bar_bloc.dart';
import 'package:project1/widgets/header_bar/widgets/battery.dart';
import 'package:project1/widgets/header_bar/widgets/home_icon.dart';
import 'package:project1/widgets/header_bar/widgets/notification_icon.dart';
import 'package:project1/widgets/header_bar/widgets/profile.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const HeaderBar({super.key, BatteryRepository? batteryRepository})
      : preferredSize = const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 40),
          child: const HomeIcon(),
        ),
        const NotificationIcon(),
        Container(
            margin: const EdgeInsets.only(right: 30), child: const Profile()),
        BlocProvider(
          create: (context) => HeaderBarBloc()..add(StartBatteryFetchEvent()),
          child: const BatteryIcon(),
        )
      ],
    );
  }
}
