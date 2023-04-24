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
  }
  switch (platformDefault) {
    case TargetPlatform.android:
      const platform = MethodChannel("samples.flutter.dev/battery");
      int batteryLevel;
      try {
        batteryLevel = await platform.invokeMethod('getBatteryLevel');
      } on PlatformException catch (e) {
        batteryLevel = -1;
      }
      return batteryLevel;
    case TargetPlatform.iOS:
      return -1;
    case TargetPlatform.macOS:
      return -1;
    case TargetPlatform.windows:
      return -1;
    case TargetPlatform.linux:
      return -1;
    default:
      return -1;
  }
}
