part of 'battery_bloc.dart';

enum BatteryPercentageFetchingStatus {
  initial,
  loading,
  succeeded,
  failed,
  notApplied
}

class BatteryState extends Equatable {
  final int? batteryPercentage;
  final BatteryPercentageFetchingStatus status;
  const BatteryState(
      {this.batteryPercentage,
      this.status = BatteryPercentageFetchingStatus.initial});
  @override
  List<dynamic> get props => [batteryPercentage, status];

  BatteryState copyWith(
      {int? batteryPercentage, BatteryPercentageFetchingStatus? status}) {
    return BatteryState(
        batteryPercentage: batteryPercentage ?? this.batteryPercentage,
        status: status ?? this.status);
  }
}
