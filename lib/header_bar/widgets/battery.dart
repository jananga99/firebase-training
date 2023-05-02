import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/battery_bloc.dart';

class BatteryIcon extends StatefulWidget {
  const BatteryIcon({Key? key}) : super(key: key);

  @override
  State<BatteryIcon> createState() => _BatteryIconState();
}

class _BatteryIconState extends State<BatteryIcon> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BatteryBloc, BatteryState>(
      buildWhen: (prev, current) => prev != current,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(right: 30),
          child: Row(
            children: [
              Text(
                state.status == BatteryPercentageFetchingStatus.succeeded &&
                        state.batteryPercentage != null
                    ? "${state.batteryPercentage!}%"
                    : "??%",
                style: const TextStyle(fontSize: 15, color: Colors.white),
              ),
              const Icon(
                Icons.battery_full,
                color: Colors.white,
                size: 30,
              )
            ],
          ),
        );
      },
    );
  }
}
