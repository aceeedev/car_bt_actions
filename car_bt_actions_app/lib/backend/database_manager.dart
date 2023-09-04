import 'package:hive_flutter/hive_flutter.dart';
import 'package:car_bt_actions/models/bt_device.dart';
import 'package:car_bt_actions/models/button_action.dart';
import 'package:car_bt_actions/models/bt_button.dart';

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

  Future<void> saveButton(BTButton btButton) async =>
      (await box).put(btButton.buttonID, btButton);

  Future<BTButton?> getButton(String buttonID) async =>
      (await box).get(buttonID);

  Future<List<BTButton>> getAllButtons() async => ((await box).values)
      .where((element) => element.runtimeType == BTButton)
      .toList()
      .cast<BTButton>();

  Future<void> deleteButton(String buttonID) async =>
      (await box).delete(buttonID);
}

Future initHive() async {
  // Initialize Hive
  await Hive.initFlutter();
  // Register custom objects in database
  // To register new TypeAdapters use:
  //   flutter packages pub run build_runner build
  Hive.registerAdapter(BTDeviceAdapter());
  Hive.registerAdapter(ButtonActionAdapter());
  Hive.registerAdapter(BTButtonAdapter());
}
