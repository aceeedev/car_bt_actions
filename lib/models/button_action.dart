import 'package:hive/hive.dart';

part 'button_action.g.dart';

@HiveType(typeId: 2)
class ButtonAction extends HiveObject {
  //List of available messages
  static const Map<String, List<String>> allowedActions = {
    'skipSong': [],
    'queueSong': ['songID']
  };

  @HiveField(0)
  String actionName;
  @HiveField(1)
  List<String> actionParameters;

  ButtonAction(this.actionName, this.actionParameters) {
    _validateAction(actionName, actionParameters);
  }

  void _validateAction(
      String unverifiedActionName, List<String> unverifiedActionParameters) {
    if (!allowedActions.keys.contains(unverifiedActionName)) {
      throw Exception('$unverifiedActionName is not a valid action name');
    } else {
      int numOfExpectedParameters =
          (allowedActions[unverifiedActionName] as List<String>).length;

      if (numOfExpectedParameters != unverifiedActionParameters.length) {
        throw Exception(
            'Expected $numOfExpectedParameters parameters for the actoin $unverifiedActionName but instead got ${unverifiedActionParameters.length}');
      }
    }
  }
}
