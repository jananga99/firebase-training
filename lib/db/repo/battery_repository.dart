import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:project1/db/model/battery.dart';

class BatteryRepository {
  dynamic getPlatform() {
    if (kIsWeb) {
      return "web";
    }
    return defaultTargetPlatform;
  }

  Future<Battery> _getBattery() async {
    final platformDefault = getPlatform();
    if ([TargetPlatform.android, TargetPlatform.iOS, TargetPlatform.macOS]
        .contains(platformDefault)) {
      const platform = MethodChannel("samples.flutter.dev/battery");
      int batteryLevel;

      batteryLevel = await platform.invokeMethod('getBatteryLevel');
      return Battery(notApplied: false, batteryPercentage: batteryLevel);
    } else {
      return const Battery(notApplied: true);
    }
  }

  Stream<Battery> query() async* {
    while (true) {
      Battery res = await _getBattery();
      yield res;
      await Future.delayed(const Duration(seconds: 60));
    }
  }
}
