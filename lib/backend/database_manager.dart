import 'package:car_bt_actions/models/bt_device.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DB {
  static final DB instance = DB._init();
  static Box? _box;

  DB._init();

  Future<Box> get box async {
    if (_box != null) return _box!;

    _box = await Hive.openBox('database');

    return _box!;
  }

  Future<void> saveBTDevice(BTDevice btDevice) async =>
      (await box).put('btDevice', btDevice);

  Future<BTDevice?> getBTDevice() async => (await box).get('btDevice');
}
