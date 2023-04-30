part of 'battery_bloc.dart';

abstract class BatteryEvent extends Equatable {
  const BatteryEvent();
  @override
  List<Object> get props => [];
}

class BatteryPercentageFetchingStarted extends BatteryEvent {}

class BatteryPercentageFetchingSucceeded extends BatteryEvent {
  final int battery;
  const BatteryPercentageFetchingSucceeded({required this.battery});
}

class BatteryPercentageFetchingFailed extends BatteryEvent {}

class BatteryPercentageFetchingNotApplied extends BatteryEvent {}
