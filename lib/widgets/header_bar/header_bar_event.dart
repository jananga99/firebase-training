part of 'header_bar_bloc.dart';

abstract class HeaderBarEvent {}

class StartBatteryFetchEvent extends HeaderBarEvent {}

class FetchBatteryEvent extends HeaderBarEvent {
  final int battery;
  FetchBatteryEvent({required this.battery});
}

class ErrorBatteryFetch extends HeaderBarEvent {}

class NotAppliedBatteryFetch extends HeaderBarEvent {}
