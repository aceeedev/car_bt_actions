import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_bt_actions/models/bt_button.dart';
import 'package:car_bt_actions/models/button_action.dart';

class BTButtonFormNotifier extends StateNotifier<BTButton> {
  BTButtonFormNotifier()
      : super(
            BTButton(buttonID: '', buttonActions: [ButtonAction('null', [])]));

  BTButtonFormNotifier.previousValue({required BTButton btButton})
      : super(btButton);

  void setButtonID(String buttonID) {
    state = state.copyWith(buttonID: buttonID);
  }

  void setButtonAction(int index, ButtonAction buttonAction) {
    List<ButtonAction> newButtonActions = state.buttonActions;
    newButtonActions[index] = buttonAction;

    state = state.copyWith(buttonActions: newButtonActions);
  }

  void addEmptyButtonAction() => state = state.copyWith(
      buttonActions: [...state.buttonActions, ButtonAction('null', [])]);
}

final btButtonFormProvider =
    StateNotifierProvider<BTButtonFormNotifier, BTButton>(
        (ref) => BTButtonFormNotifier());
