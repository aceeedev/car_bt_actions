import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/bt_device.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() {
    return _instance;
  }

  BTDevice? btDevice;
  late BluetoothConnection connection;

  BluetoothManager._internal() {}

  Future connect() async {
    btDevice = await DB.instance.getBTDevice();

    try {
      connection = await BluetoothConnection.toAddress(btDevice?.address);
      print('Device is ${connection.isConnected}');
      print('Connected to the device');
    } catch (exception) {
      print('Cannot connect, exception occured $exception\n\n');
    }
  }

  void listen() {
    connection.input?.listen((Uint8List data) {
      String message = ascii.decode(data);
      print('Data incoming: $message');
    });
  }

  // rest of class as normal, for example:
  void openFile() {}
  void writeFile() {}
}
