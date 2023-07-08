import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:car_bt_actions/backend/bluetooth_checker.dart';
import 'package:car_bt_actions/pages/discovery_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void _incrementCounter() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DiscoveryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async => await askForPermissions(),
              child: const Text('Get Permissions'),
            ),
            ElevatedButton(
              onPressed: () async => await bluetoothChecker(),
              child: const Text('Bluetooth checker'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future askForPermissions() async {
    List<Permission> permissionList = [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetooth,
    ];

    for (Permission permission in permissionList) {
      var status = await permission.status;

      // check if user has enable the permission
      if (!status.isGranted) {
        await permission.request();
      }
    }
  }
}
