import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/app.dart';

void main() async {
  // Allows for async code in main method
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();

  runApp(const ProviderScope(child: App()));
}
