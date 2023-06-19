import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:car_bt_actions/app.dart';
import 'package:car_bt_actions/models/bt_device.dart';

void main() async {
  // Allows for async code in main method
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();
  // Register custom objects in database
  // To register new TypeAdapters use:
  //   flutter packages pub run build_runner build
  Hive.registerAdapter(BTDeviceAdapter());

  runApp(const App());
}
