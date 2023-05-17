import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:project1/repositories/battery_repository/battery_repository.dart';

part 'header_bar_event.dart';
part 'header_bar_state.dart';

class HeaderBarBloc extends Bloc<HeaderBarEvent, HeaderBarState> {
  HeaderBarBloc() : super(HeaderBarState.initialState) {
    on<StartBatteryFetchEvent>(_onBatteryPercentageFetchingStarted);
    on<NotAppliedBatteryFetch>(_onBatteryPercentageFetchingNotApplied);
    on<FetchBatteryEvent>(_onBatteryPercentageFetchingSucceeded);
    on<ErrorBatteryFetch>(_onBatteryPercentageFetchingFailed);
  }

  final BatteryRepository _batteryRepository = BatteryRepository();
  StreamSubscription<BatteryPercentageResult>? _batterySubscription;

  @override
  Future<void> close() {
    _batterySubscription?.cancel();
    return super.close();
  }

  Future<void> _onBatteryPercentageFetchingStarted(
      StartBatteryFetchEvent event, Emitter<HeaderBarState> emit) async {
    emit(state.clone(status: BatteryFetchingStatus.loading));

    _batterySubscription = _batteryRepository
        .getBatteryPercentageStream()
        .listen((BatteryPercentageResult event) {
      if (event.notApplied) {
        add(NotAppliedBatteryFetch());
      } else if (event.batteryPercentage == null) {
        add(ErrorBatteryFetch());
      } else {
        add(FetchBatteryEvent(battery: event.batteryPercentage!));
      }
    });
  }

  void _onBatteryPercentageFetchingSucceeded(
      FetchBatteryEvent event, Emitter<HeaderBarState> emit) {
    emit(state.clone(
        status: BatteryFetchingStatus.succeeded,
        batteryPercentage: event.battery));
  }

  void _onBatteryPercentageFetchingNotApplied(
      NotAppliedBatteryFetch event, Emitter<HeaderBarState> emit) async {
    emit(state.clone(status: BatteryFetchingStatus.notApplied));
  }

  void _onBatteryPercentageFetchingFailed(
      ErrorBatteryFetch event, Emitter<HeaderBarState> emit) {
    emit(state.clone(status: BatteryFetchingStatus.failed));
  }
}
