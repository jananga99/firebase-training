import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/battery_bloc.dart';

class Battery extends StatefulWidget {
  const Battery({Key? key}) : super(key: key);

  @override
  State<Battery> createState() => _BatteryState();
}

class _BatteryState extends State<Battery> {
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
