part of 'header_bar_bloc.dart';

enum BatteryFetchingStatus { initial, loading, succeeded, failed, notApplied }

class HeaderBarState {
  final int? battery;
  final BatteryFetchingStatus status;
  const HeaderBarState({required this.battery, required this.status});

  static HeaderBarState get initialState => const HeaderBarState(
      battery: null, status: BatteryFetchingStatus.initial);

  HeaderBarState clone(
      {int? batteryPercentage, BatteryFetchingStatus? status}) {
    return HeaderBarState(
        battery: batteryPercentage ?? this.battery,
        status: status ?? this.status);
  }
}
