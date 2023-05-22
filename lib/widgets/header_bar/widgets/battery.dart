import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/widgets/custom/custom_colors.dart';
import 'package:project1/widgets/header_bar/header_bar_bloc.dart';

class BatteryIcon extends StatefulWidget {
  const BatteryIcon({Key? key}) : super(key: key);

  @override
  State<BatteryIcon> createState() => _BatteryIconState();
}

class _BatteryIconState extends State<BatteryIcon> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeaderBarBloc, HeaderBarState>(
      buildWhen: (prev, current) => prev != current,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(right: 30),
          child: Row(
            children: [
              Text(
                state.status == BatteryFetchingStatus.succeeded &&
                        state.battery != null
                    ? "${state.battery!}%"
                    : "??%",
                style: const TextStyle(
                    fontSize: 15, color: CustomColors.ICON_BACKGROUND),
              ),
              Icon(
                Icons.battery_full,
                color: Theme.of(context).colorScheme.onBackground,
                size: 30,
              )
            ],
          ),
        );
      },
    );
  }
}
