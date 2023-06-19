import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/bt_device.dart';
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
              onPressed: () async {
                BTDevice? btDevice = await DB.instance.getBTDevice();

                print(
                    'Device: ${btDevice == null ? 'Null' : btDevice.address}');
              },
              child: const Text('Get Saved Device'),
            )
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
