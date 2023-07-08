import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:car_bt_actions/app.dart';

void main() async {
  // Allows for async code in main method
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  runApp(const App());
}
