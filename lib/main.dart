import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:car_bt_actions/app.dart';
import 'package:car_bt_actions/backend/bluetooth_checker.dart';

const String backgroundTask = 'checkBluetooth';
const Duration timeBetweenBackgroundTasks = Duration(seconds: 10);

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await bluetoothChecker();

    // loop background tasks to have a periodic task with a freq less than 15 mins
    Workmanager().registerOneOffTask(backgroundTask, backgroundTask,
        initialDelay: timeBetweenBackgroundTasks,
        existingWorkPolicy: ExistingWorkPolicy.append);
    return Future.value(true);
  });
}

void main() async {
  // Allows for async code in main method
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  Workmanager().cancelAll();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask(backgroundTask, backgroundTask,
      initialDelay: timeBetweenBackgroundTasks);

  runApp(const App());
}
