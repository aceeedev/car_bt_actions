import 'package:flutter/material.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/button_action.dart';
import 'package:car_bt_actions/models/bt_button.dart';

class BTButtonFormPage extends StatefulWidget {
  const BTButtonFormPage({super.key});

  @override
  State<BTButtonFormPage> createState() => _BTButtonFormPageState();
}

class _BTButtonFormPageState extends State<BTButtonFormPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add New Button'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: BTButtonForm(),
      ),
    );
  }
}

class BTButtonForm extends StatefulWidget {
  const BTButtonForm({super.key});

  // TODO: make list dynamic
  static List<String> possibleButtons = ['34', '35', '36', '39'];

  @override
  State<BTButtonForm> createState() => _BTButtonFormState();
}

class _BTButtonFormState extends State<BTButtonForm> {
  final _formKey = GlobalKey<FormState>();

  // form values
  late String? button;
  late String? action;
  late List<String> parameters = [];

  List<Widget> parameterWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButtonFormField(
              validator: (value) => selectedValidator(value),
              items: BTButtonForm.possibleButtons
                  .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              onChanged: (String? value) => button = value),
          DropdownButtonFormField(
              validator: (value) => selectedValidator(value),
              items: ButtonAction.allowedActions.entries
                  .map((e) => DropdownMenuItem<String>(
                      value: e.key, child: Text(e.key)))
                  .toList(),
              onChanged: (String? value) {
                action = value;

                int numberOfParameters =
                    ButtonAction.allowedActions[action]!.length;
                parameterWidgets = [];

                if (numberOfParameters > 0) {
                  // add new parameter text fields
                  for (int i = 0; i < numberOfParameters; i++) {
                    String parameter = ButtonAction.allowedActions[action]![i];

                    parameterWidgets.add(TextFormField(
                      initialValue: parameter,
                      validator: (String? value) => selectedValidator(value),
                      onChanged: (value) => parameters[i] = value,
                    ));
                  }
                }

                setState(() {
                  parameterWidgets = parameterWidgets;
                });
              }),
          ...parameterWidgets,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ButtonAction buttonAction = ButtonAction(action!, parameters);

                  // check if button already exists
                  BTButton? previousBTButton =
                      await DB.instance.getButton(button!);
                  if (previousBTButton != null) {
                    previousBTButton.buttonActions.add(buttonAction);

                    previousBTButton.save();
                  } else {
                    BTButton newBTButton = BTButton(
                        buttonID: button!, buttonActions: [buttonAction]);

                    await DB.instance.saveButton(newBTButton);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  String? selectedValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }
}
