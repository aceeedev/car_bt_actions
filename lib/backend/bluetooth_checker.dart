import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/bt_device.dart';

Future bluetoothChecker() async {
  // initialize hive in new background isolate, only read, don't write
  await initHive();

  BTDevice? btDevice = await DB.instance.getBTDevice();

  try {
    BluetoothConnection connection =
        await BluetoothConnection.toAddress(btDevice?.address);
    print('Device is ${connection.isConnected}');

    print('Connected to the device');

    connection.input?.listen((Uint8List data) {
      String message = ascii.decode(data);
      print('Data incoming: $message');
    });
  } catch (exception) {
    print('Cannot connect, exception occured $exception\n\n');
  }
}
