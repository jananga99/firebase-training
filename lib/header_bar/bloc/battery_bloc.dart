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
  StreamSubscription<BatteryPercentageResult>? _batterySubscription;

  @override
  Future<void> close() {
    _batterySubscription?.cancel();
    return super.close();
  }

  Future<void> _onBatteryPercentageFetchingStarted(
      BatteryPercentageFetchingStarted event,
      Emitter<BatteryState> emit) async {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.loading));

    _batterySubscription = _batteryRepository
        .getBatteryPercentageStream()
        .listen((BatteryPercentageResult event) {
      if (event.notApplied) {
        add(BatteryPercentageFetchingNotApplied());
      } else if (event.batteryPercentage == null) {
        add(BatteryPercentageFetchingFailed());
      } else {
        add(BatteryPercentageFetchingSucceeded(
            battery: event.batteryPercentage!));
      }
    });
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
