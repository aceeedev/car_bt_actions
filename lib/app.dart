import 'package:flutter/material.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/bt_device.dart';
import 'package:car_bt_actions/pages/home_page.dart';
import 'package:car_bt_actions/pages/setup_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Car Bluetooth Actions',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('An error has occurred, ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  BTDevice? btDevice = snapshot.data;

                  return btDevice != null
                      ? const HomePage()
                      : const SetupPage();
                }
              }

              return const Center(child: CircularProgressIndicator());
            }),
            future: DB.instance.getBTDevice()));
  }
}
