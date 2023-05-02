import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:project1/repositories/battery_repository/models/battery_percentage_result.dart';

export 'models/models.dart';

class BatteryRepository {
  dynamic getPlatform() {
    if (kIsWeb) {
      return "web";
    }
    return defaultTargetPlatform;
  }

  Future<BatteryPercentageResult> getBatteryPercentage() async {
    final platformDefault = getPlatform();
    if ([TargetPlatform.android, TargetPlatform.iOS, TargetPlatform.macOS]
        .contains(platformDefault)) {
      const platform = MethodChannel("samples.flutter.dev/battery");
      int batteryLevel;
      try {
        batteryLevel = await platform.invokeMethod('getBatteryLevel');
        return BatteryPercentageResult(
            notApplied: false, batteryPercentage: batteryLevel);
      } on PlatformException {
        return const BatteryPercentageResult(notApplied: false);
      }
    } else {
      return const BatteryPercentageResult(notApplied: true);
    }
  }
}
