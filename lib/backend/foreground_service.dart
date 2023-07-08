import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:car_bt_actions/backend/bluetooth_checker.dart';
import 'package:car_bt_actions/backend/database_manager.dart';

@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async =>
      await initHive();

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    print('ran');
    bluetoothChecker();
  }

  // Called when the notification button on the Android platform is pressed.
  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {}
}
