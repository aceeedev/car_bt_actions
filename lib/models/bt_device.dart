import 'package:hive/hive.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bt_device.g.dart';

@HiveType(typeId: 1)
class BTDevice extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  late String address;

  BTDevice({required this.name, required this.address});

  /// Constructor that takes in a [BluetoothDevice] parameter
  BTDevice.device({required BluetoothDevice bluetoothDevice}) {
    name = bluetoothDevice.name;
    address = bluetoothDevice.address;
  }
}
