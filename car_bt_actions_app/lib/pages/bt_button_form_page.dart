import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/providers/bt_button_form_provider.dart';
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

class BTButtonForm extends ConsumerStatefulWidget {
  const BTButtonForm({super.key});

  // TODO: make list dynamic
  static List<String> possibleButtons = ['34', '35', '36', '39'];

  @override
  _BTButtonFormState createState() => _BTButtonFormState();
}

class _BTButtonFormState extends ConsumerState<BTButtonForm> {
  final _formKey = GlobalKey<FormState>();

  List<Widget> buttonActionForms = [
    ButtonActionForm(
      selectedValidator: selectedValidator,
      index: 0,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final btButtonFormValues = ref.watch(btButtonFormProvider);

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
              onChanged: (String? value) =>
                  ref.read(btButtonFormProvider.notifier).setButtonID(value!)),
          ...buttonActionForms,
          ElevatedButton(
              onPressed: () {
                ref.read(btButtonFormProvider.notifier).addEmptyButtonAction();

                setState(() => buttonActionForms.add(ButtonActionForm(
                      selectedValidator: selectedValidator,
                      index: buttonActionForms.length,
                    )));
              },
              child: const Icon(Icons.add)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // check if button already exists
                  BTButton? previousBTButton =
                      await DB.instance.getButton(btButtonFormValues.buttonID);
                  if (previousBTButton != null) {
                    const snackBar = SnackBar(
                      content: Text(
                          'This button already has an action assigned to it.'),
                    );

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    await DB.instance.saveButton(btButtonFormValues);
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

  static String? selectedValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }
}

class ButtonActionForm extends ConsumerStatefulWidget {
  ButtonActionForm(
      {super.key, required this.selectedValidator, required this.index});
  Function selectedValidator;
  int index;

  @override
  _ButtonActionFormState createState() => _ButtonActionFormState();
}

class _ButtonActionFormState extends ConsumerState<ButtonActionForm> {
  List<Widget> parameterWidgets = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final btButtonFormValues = ref.watch(btButtonFormProvider);

    return Column(
      children: [
        DropdownButtonFormField(
            validator: (value) => widget.selectedValidator(value),
            items: ButtonAction.allowedActions.entries
                .map((e) =>
                    DropdownMenuItem<String>(value: e.key, child: Text(e.key)))
                .toList(),
            onChanged: (String? actionNameValue) {
              int numberOfParameters =
                  ButtonAction.allowedActions[actionNameValue]!.length;

              ref.read(btButtonFormProvider.notifier).setButtonAction(
                  widget.index,
                  btButtonFormValues.buttonActions[widget.index].copyWith(
                      actionName: actionNameValue,
                      actionParameters: List.filled(numberOfParameters, '')));

              parameterWidgets = [];

              if (numberOfParameters > 0) {
                // add new parameter text fields
                for (int i = 0; i < numberOfParameters; i++) {
                  String parameter =
                      ButtonAction.allowedActions[actionNameValue]![i];

                  parameterWidgets.add(TextFormField(
                    initialValue: parameter,
                    validator: (String? value) =>
                        widget.selectedValidator(value),
                    onChanged: (actionParameterValue) => ref
                        .read(btButtonFormProvider.notifier)
                        .setButtonAction(
                            widget.index,
                            btButtonFormValues.buttonActions[widget.index]
                                .copyWithNewParameter(i, actionParameterValue)),
                  ));
                }
              }

              setState(() {
                parameterWidgets = parameterWidgets;
              });
            }),
        ...parameterWidgets
      ],
    );
  }
}
