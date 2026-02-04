import 'package:flutter/services.dart';

class BatteryService {
  static const _channel = MethodChannel('battery_channel');

  static Future<int> getBatteryLevel() async {
    final int level = await _channel.invokeMethod('getBatteryLevel');
    return level;
  }
}