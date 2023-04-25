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
  } else if ([
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.linux,
    TargetPlatform.macOS
  ].contains(platformDefault)) {
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

Future<int> getBatteryPercentageStream() async {
  final platformDefault = getPlatform();
  if (platformDefault == "web") {
    return -2;
  } else if ([
    TargetPlatform.android,
    TargetPlatform.iOS,
    TargetPlatform.linux,
    TargetPlatform.macOS
  ].contains(platformDefault)) {
    const platform = EventChannel("samples.flutter.dev/battery");
    final stream = platform.receiveBroadcastStream();
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
