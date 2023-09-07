import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:car_bt_actions/secrets.dart' as secrets;
import 'package:car_bt_actions/backend/bluetooth_manager.dart';
import 'package:car_bt_actions/pages/discovery_page.dart';
import 'package:car_bt_actions/pages/home_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late BluetoothManager bluetoothManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Setup Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async => askForPermissions(),
              child: const Text('Accept Permissions'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DiscoveryPage(),
                ),
              ),
              child: const Text('Choose Bluetooth Device'),
            ),
            ElevatedButton(
              onPressed: () async => await SpotifySdk.connectToSpotifyRemote(
                  clientId: secrets.spotifyClientID,
                  redirectUrl: 'xyz.andrewcollins.car-bt-action://'),
              child: const Text('Connect to Spotify'),
            ),
            ElevatedButton(
              onPressed: () async =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomePage(),
              )),
              child: const Text('Go to Home Page'),
            ),
          ],
        ),
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
