import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/repositories.dart';

part 'battery_state.dart';

class BatteryCubit extends Cubit<BatteryState> {
  BatteryCubit(this._batteryRepository) : super(const BatteryState());
  final BatteryRepository _batteryRepository;

  Future<void> fetchPercentage() async {
    emit(state.copyWith(status: BatteryPercentageFetchingStatus.loading));
    final BatteryPercentageResult result =
        await _batteryRepository.getBatteryPercentage();
    if (result.notApplied) {
      notApplyFetchPercentage();
    } else if (result.batteryPercentage != null) {
      successFetchPercentage(result.batteryPercentage!);
    } else {
      failFetchPercentage();
    }
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
