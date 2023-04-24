import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

dynamic getPlatform() {
  if (kIsWeb) {
    return "web";
  }
  return defaultTargetPlatform;
}

Future<int> getBatteryPercentage() async {
  final platformDefault = getPlatform();
  if (platformDefault == "web") {
    return -2;
  } else if (platformDefault == TargetPlatform.android ||
      platformDefault == TargetPlatform.iOS) {
    const platform = MethodChannel("samples.flutter.dev/battery");
    int batteryLevel;
    try {
      batteryLevel = await platform.invokeMethod('getBatteryLevel');
    } on PlatformException {
      batteryLevel = -1;
    }
    return batteryLevel;
  } else {
    return -2;
  }
}
