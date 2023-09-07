import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/providers/bt_button_form_provider.dart';
import 'package:car_bt_actions/models/button_action.dart';
import 'package:car_bt_actions/models/bt_button.dart';

class BTButtonFormPage extends ConsumerStatefulWidget {
  const BTButtonFormPage({super.key, this.previousBTButton});

  final BTButton?
      previousBTButton; // when passed, it fills in form with values for editing

  @override
  _BTButtonFormPageState createState() => _BTButtonFormPageState();
}

class _BTButtonFormPageState extends ConsumerState<BTButtonFormPage> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: widget.previousBTButton != null
          ? [
              btButtonFormProvider.overrideWith((ref) =>
                  BTButtonFormNotifier.fromPreviousValue(
                      btButton: widget.previousBTButton!))
            ]
          : [],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.previousBTButton == null
              ? 'Add New Button'
              : 'Edit Button ${widget.previousBTButton!.buttonID}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BTButtonForm(previousBTButton: widget.previousBTButton),
        ),
      ),
    );
  }
}

class BTButtonForm extends ConsumerStatefulWidget {
  const BTButtonForm({super.key, this.previousBTButton});

  final BTButton? previousBTButton;

  // TODO: make list dynamic
  static List<String> possibleButtons = ['34', '35', '36', '39'];

  @override
  _BTButtonFormState createState() => _BTButtonFormState();
}

class _BTButtonFormState extends ConsumerState<BTButtonForm> {
  final _formKey = GlobalKey<FormState>();

  List<Widget> buttonActionForms = [
    const ButtonActionForm(
      selectedValidator: selectedValidator,
      index: 0,
    )
  ];

  @override
  void initState() {
    super.initState();

    if (widget.previousBTButton != null) {
      buttonActionForms = [];

      for (int i = 0; i < widget.previousBTButton!.buttonActions.length; i++) {
        ButtonAction buttonAction = widget.previousBTButton!.buttonActions[i];

        if (buttonAction.actionName != 'null') {
          buttonActionForms.add(ButtonActionForm(
            selectedValidator: selectedValidator,
            index: i,
            previousButtonAction: buttonAction,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final btButtonFormValues = ref.watch(btButtonFormProvider);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButtonFormField<String>(
              value: widget.previousBTButton?.buttonID,
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
                  if (previousBTButton != null &&
                      widget.previousBTButton == null) {
                    const snackBar = SnackBar(
                      content: Text(
                          'This button already has an action assigned to it.'),
                    );

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    await DB.instance.saveButton(btButtonFormValues);

                    if (!mounted) return;
                    Navigator.pop(context);
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
  const ButtonActionForm(
      {super.key,
      required this.selectedValidator,
      required this.index,
      this.previousButtonAction});
  final Function selectedValidator;
  final int index;

  final ButtonAction? previousButtonAction;

  @override
  _ButtonActionFormState createState() => _ButtonActionFormState();
}

class _ButtonActionFormState extends ConsumerState<ButtonActionForm> {
  List<Widget> parameterWidgets = [];

  @override
  void initState() {
    super.initState();

    if (widget.previousButtonAction != null) {
      List<String> previousActionParameters =
          widget.previousButtonAction!.actionParameters;

      _addParameterFields(
          previousActionParameters.length,
          widget.previousButtonAction!.actionName,
          ref.read(btButtonFormProvider),
          true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final btButtonFormValues = ref.watch(btButtonFormProvider);

    return Column(
      children: [
        DropdownButtonFormField<String>(
            value: widget.previousButtonAction?.actionName,
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
                _addParameterFields(numberOfParameters, actionNameValue!,
                    btButtonFormValues, false);

                setState(() {
                  parameterWidgets = parameterWidgets;
                });
              }
            }),
        ...parameterWidgets
      ],
    );
  }

  void _addParameterFields(int numberOfParameters, String actionNameValue,
      BTButton btButtonFormValues, bool fromPreviousButtonAction) {
    for (int i = 0; i < numberOfParameters; i++) {
      String parameter = ButtonAction.allowedActions[actionNameValue]![i];

      parameterWidgets.add(TextFormField(
          initialValue: fromPreviousButtonAction
              ? widget.previousButtonAction?.actionParameters[i]
              : null,
          decoration: InputDecoration(hintText: parameter),
          validator: (String? value) => widget.selectedValidator(value),
          onChanged: (actionParameterValue) {
            String actionParameter = actionParameterValue;

            if (actionNameValue == 'queueSong' &&
                actionParameterValue
                    .contains('https://open.spotify.com/track/')) {
              actionParameter = actionParameterValue =
                  'spotify:track:${Uri.parse(actionParameterValue).pathSegments[1]}';
            }

            ref.read(btButtonFormProvider.notifier).setButtonAction(
                widget.index,
                btButtonFormValues.buttonActions[widget.index]
                    .copyWithNewParameter(i, actionParameter));
          }));
    }
  }
}
