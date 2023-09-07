import 'package:flutter/material.dart';
import 'package:car_bt_actions/backend/bluetooth_manager.dart';
import 'package:car_bt_actions/backend/database_manager.dart';
import 'package:car_bt_actions/models/bt_button.dart';
import 'package:car_bt_actions/pages/setup_page.dart';
import 'package:car_bt_actions/pages/bt_button_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BluetoothManager bluetoothManager;

  @override
  void initState() {
    super.initState();

    setupBluetoothManager();
  }

  Future setupBluetoothManager() async {
    bluetoothManager = BluetoothManager();

    await bluetoothManager.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () => setupBluetoothManager(),
              icon: const Icon(Icons.bluetooth_connected)),
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SetupPage())),
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: FutureBuilder(
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('An error has occurred, ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<BTButton> btButtons = snapshot.data as List<BTButton>;

                return btButtons.isNotEmpty
                    ? ListView.builder(
                        itemCount: btButtons.length,
                        itemBuilder: (context, index) {
                          BTButton btButton = btButtons[index];

                          List<Text> actionTexts = btButton.buttonActions
                              .map((e) => Text(e.actionName))
                              .toList();

                          return Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Button ${btButton.buttonID}'),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: DropdownButton(
                                        onChanged: (value) {
                                          switch (value) {
                                            case 'delete':
                                              {
                                                DB.instance.deleteButton(
                                                    btButton.buttonID);
                                              }
                                              break;

                                            case 'edit':
                                              {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BTButtonFormPage(
                                                                previousBTButton:
                                                                    btButton))).then(
                                                    (_) => setState(
                                                          () {},
                                                        ));
                                              }
                                              break;
                                          }

                                          setState(() {});
                                        },
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'delete',
                                            child: Icon(Icons.delete),
                                          ),
                                          DropdownMenuItem(
                                            value: 'edit',
                                            child: Icon(Icons.edit),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                ...actionTexts
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('You do not have any buttons saved'));
              }
            }

            return const Center(child: CircularProgressIndicator());
          }),
          future: DB.instance.getAllButtons()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => const BTButtonFormPage()))
            .then((_) => setState(
                  () {},
                )),
        child: const Icon(Icons.add),
      ),
    );
  }
}
