import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/repositories/battery_repository/battery_repository.dart';

import '../bloc/battery_bloc.dart';
import '../widgets/widgets.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final BatteryRepository _batteryRepository;

  @override
  final Size preferredSize;

  HeaderBar({super.key, BatteryRepository? batteryRepository})
      : preferredSize = const Size.fromHeight(56.0),
        _batteryRepository = batteryRepository ?? BatteryRepository();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xff00ffff),
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 40),
          child: const HomeIcon(),
        ),
        const NotificationIcon(),
        Container(
            margin: const EdgeInsets.only(right: 30), child: const Profile()),
        RepositoryProvider(
          create: (context) => _batteryRepository,
          child: BlocProvider(
            create: (context) => BatteryBloc(_batteryRepository)
              ..add(BatteryPercentageFetchingStarted()),
            child: const BatteryIcon(),
          ),
        )
      ],
    );
  }
}
