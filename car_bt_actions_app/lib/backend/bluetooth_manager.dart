import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:car_bt_actions/models/bt_button.dart';
import 'package:car_bt_actions/models/button_action.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/bt_device.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() {
    return _instance;
  }

  BTDevice? btDevice;
  late BluetoothConnection _connection;

  bool get isConnected => _connection.isConnected;

  BluetoothManager._internal();

  Future connect(
      {int retries = 12,
      Duration timeBetweenRetries = const Duration(seconds: 10)}) async {
    btDevice = await DB.instance.getBTDevice();

    int i = 0;
    while (i < retries) {
      try {
        _connection = await BluetoothConnection.toAddress(btDevice?.address);

        if (_connection.isConnected) {
          break;
        }
      } catch (exception) {
        print('Cannot connect, exception occured $exception\n\n');
      }

      await Future.delayed(timeBetweenRetries);

      i++;
    }

    if (_connection.isConnected) {
      print('Connected to the device');
      _listen();
    }
  }

  void _listen() {
    _connection.input?.listen((Uint8List data) {
      // message is composed of 2 parts: buttonPin_typeOfPress
      //  ex: 34_0 means button from the pin 34 was pressed and it was a single
      //  press
      // note: for now it only accepts single presses as in just in the
      //  buttonPin
      String message = ascii.decode(data);
      print('Data incoming: $message');

      _decodeMessage(message);
    });
  }

  Future _decodeMessage(String message) async {
    BTButton? btButton = await DB.instance.getButton(message);
    if (btButton != null) {
      for (ButtonAction buttonAction in btButton.buttonActions) {
        switch (buttonAction.actionName) {
          case 'skipSong':
            {
              SpotifySdk.skipNext();
            }
            break;

          case 'queueSong':
            {
              SpotifySdk.queue(spotifyUri: buttonAction.actionParameters.first);
            }
            break;
        }

        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
  }
}
