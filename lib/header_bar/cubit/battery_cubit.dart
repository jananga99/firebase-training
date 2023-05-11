import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repositories.dart';

part 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  BatteryCubit(this._batteryRepository) : super(const BatteryState());
  final BatteryRepository _batteryRepository;
  StreamSubscription<BatteryPercentageResult>? _batterySubscription;

  @override
  Future<void> close() {
    _batterySubscription?.cancel();
    return super.close();
  }

  Future<void> startFetchPercentage() async {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.loading));
    _batterySubscription = _batteryRepository
        .getBatteryPercentageStream()
        .listen((BatteryPercentageResult event) {
      if (event.notApplied) {
        notApplyFetchPercentage();
      } else if (event.batteryPercentage == null) {
        failFetchPercentage();
      } else {
        successFetchPercentage(event.batteryPercentage!);
      }
    });
  }

  void successFetchPercentage(int battery) {
    emit(state.copyWith(
        status: BatteryPercentageFetchingStatus.succeeded,
        batteryPercentage: battery));
  }

  void notApplyFetchPercentage() async {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.notApplied));
  }

  void failFetchPercentage() {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.failed));
  }
}
