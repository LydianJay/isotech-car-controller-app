import 'package:isotech_smart_car_app/font/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:isotech_smart_car_app/views/controllerview.dart';
import 'package:flutter/services.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final TextEditingController ipCtrl =
      TextEditingController(text: '192.168.1.1');
  final TextEditingController portCtrl = TextEditingController(text: '80');
  StreamSubscription<List<int>>? _notifySub;
  List<Device> discoveredDevices = List.empty(growable: true);

  int armState = 0;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
 
  @override
  void dispose() {
    _notifySub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect to device'),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              Navigator.pushNamed(context, '/devinfoview');
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xfff8f9fa),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: ipCtrl,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'IP Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: portCtrl,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Port',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton.filledTonal(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ControllerView(
                        ipAdd: ipCtrl.text,
                        port: int.parse(portCtrl.value.text),
                      ),
                    ),
                  );
                },
                icon: SizedBox(
                  width: scrWidth * 0.3,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Connect'),
                      Icon(Icons.wifi),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
