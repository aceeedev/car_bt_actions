// ignore: depend_on_referenced_packages
//import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:car_bt_actions/models/bt_device.dart';

class DB {
  static final DB instance = DB._init();
  static Box? _box;

  DB._init();

  Future<Box> get box async {
    if (_box != null) return _box!;

    _box = await Hive.openBox(
      'database', /* path: (await getApplicationDocumentsDirectory()).path */
    );

    return _box!;
  }

  Future<void> saveBTDevice(BTDevice btDevice) async =>
      (await box).put('btDevice', btDevice);

  Future<BTDevice?> getBTDevice() async => (await box).get('btDevice');
}

Future initHive() async {
  // Initialize Hive
  await Hive.initFlutter();
  // Register custom objects in database
  // To register new TypeAdapters use:
  //   flutter packages pub run build_runner build
  Hive.registerAdapter(BTDeviceAdapter());
}
