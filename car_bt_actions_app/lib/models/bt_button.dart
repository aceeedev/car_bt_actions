import 'package:hive/hive.dart';
import 'package:car_bt_actions/models/button_action.dart';

part 'bt_button.g.dart';

@HiveType(typeId: 3)
class BTButton extends HiveObject {
  @HiveField(0)
  String buttonID;
  @HiveField(1)
  List<ButtonAction> buttonActions;

  BTButton({required this.buttonID, required this.buttonActions});

  BTButton copyWith({String? buttonID, List<ButtonAction>? buttonActions}) =>
      BTButton(
        buttonID: buttonID ?? this.buttonID,
        buttonActions: buttonActions ?? this.buttonActions,
      );
}
