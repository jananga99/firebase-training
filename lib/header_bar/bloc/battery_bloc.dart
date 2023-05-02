import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project1/repositories/battery_repository/battery_repository.dart';

part 'battery_event.dart';
part 'battery_state.dart';

class BatteryBloc extends Bloc<BatteryEvent, BatteryState> {
  BatteryBloc(this._batteryRepository) : super(const BatteryState()) {
    on<BatteryPercentageFetchingStarted>(_onBatteryPercentageFetchingStarted);
    on<BatteryPercentageFetchingNotApplied>(
        _onBatteryPercentageFetchingNotApplied);
    on<BatteryPercentageFetchingSucceeded>(
        _onBatteryPercentageFetchingSucceeded);
    on<BatteryPercentageFetchingFailed>(_onBatteryPercentageFetchingFailed);
  }

  final BatteryRepository _batteryRepository;

  Future<void> _onBatteryPercentageFetchingStarted(
      BatteryPercentageFetchingStarted event,
      Emitter<BatteryState> emit) async {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.loading));
    final BatteryPercentageResult result =
        await _batteryRepository.getBatteryPercentage();
    if (result.notApplied) {
      add(BatteryPercentageFetchingNotApplied());
    } else if (result.batteryPercentage != null) {
      add(BatteryPercentageFetchingSucceeded(
          battery: result.batteryPercentage!));
    } else {
      add(BatteryPercentageFetchingFailed());
    }
  }

  void _onBatteryPercentageFetchingSucceeded(
      BatteryPercentageFetchingSucceeded event, Emitter<BatteryState> emit) {
    emit(state.copyWith(
        status: BatteryPercentageFetchingStatus.succeeded,
        batteryPercentage: event.battery));
  }

  void _onBatteryPercentageFetchingNotApplied(
      BatteryPercentageFetchingNotApplied event,
      Emitter<BatteryState> emit) async {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.notApplied));
  }

  void _onBatteryPercentageFetchingFailed(
      BatteryPercentageFetchingFailed event, Emitter<BatteryState> emit) {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.failed));
  }
}
