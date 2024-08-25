import 'dart:ffi';
import 'package:isotech_smart_car_app/font/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:isotech_smart_car_app/views/controllerview.dart';
import 'package:flutter/services.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _ble = FlutterReactiveBle();
  StreamSubscription<DiscoveredDevice>? _scanSub;
  StreamSubscription<ConnectionStateUpdate>? _connectSub;
  StreamSubscription<List<int>>? _notifySub;
  List<DiscoveredDevice> discoveredDevices = List.empty(growable: true);
  String? id;
  Uuid? serviceId;
  Uuid? charId;

  int armState = 0;
  @override
  void initState() {
    super.initState();
    if (_connectSub != null) {
      _connectSub!.cancel();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _dialogBuilder(BuildContext context, String blName) {
    double scrWidth = MediaQuery.of(context).size.width;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Connecting to $blName '),
            content: Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              width: scrWidth * 0.1,
              height: scrWidth * 0.5,
              child: const CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget buildList(
      double scrWidth, double scrHeight, DiscoveredDevice? device) {
    if (discoveredDevices.isEmpty) {
      discoveredDevices.add(
        DiscoveredDevice(
          id: device!.id,
          name: device.name,
          serviceData: device.serviceData,
          manufacturerData: device.manufacturerData,
          rssi: device.rssi,
          serviceUuids: device.serviceUuids,
        ),
      );
    } else {
      if (device!.name.isNotEmpty) {
        bool alreadyInList = false;

        for (var d in discoveredDevices) {
          if (d.name == device.name) {
            alreadyInList = true;
          }
        }

        if (!alreadyInList) {
          debugPrint('Found device: ${device.name}');
          discoveredDevices.add(
            DiscoveredDevice(
              id: device.id,
              name: device.name,
              serviceData: device.serviceData,
              manufacturerData: device.manufacturerData,
              rssi: device.rssi,
              serviceUuids: device.serviceUuids,
            ),
          );
        }
      }
    }

    final List<Widget> list = [];

    for (var d in discoveredDevices) {
      list.add(Container(
        width: scrWidth * 0.9,
        height: scrHeight * 0.2,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: const Color(0xffdc3545),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color.fromARGB(255, 88, 21, 28)),
        ),
        child: Column(
          children: [
            Text(
              "Device name: ${d.name}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text("ID: ${d.id}"),
            Text(
                "Service ID: ${d.serviceUuids.isNotEmpty ? d.serviceUuids.first.toString() : 'Not Available'}"),
            Text(
                "Char. ID: ${d.serviceUuids.length >= 2 ? d.serviceUuids[1].toString() : 'Not Available'}"),
            IconButton.filledTonal(
              onPressed: () async {
                if (_connectSub != null) {
                  await _connectSub!.cancel();
                }
                _dialogBuilder(context, d.name);
                _connectSub = _ble.connectToDevice(id: d.id).listen((update) {
                  if (update.connectionState ==
                      DeviceConnectionState.connected) {
                    debugPrint('Connected!');
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ControllerView(
                          serviceID: d.serviceUuids[0],
                          charID: d.serviceUuids[1],
                          id: d.id,
                          ble: _ble,
                          connectSub: _connectSub,
                        ),
                      ),
                    );
                  }
                });
              },
              icon: SizedBox(
                width: scrWidth * 0.3,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Connect'),
                    Icon(CustomIcon.bluetooth_connected)
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: list,
      ),
    );
  }

  @override
  void dispose() {
    _notifySub?.cancel();
    _connectSub?.cancel();
    _scanSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xfff8f9fa),
        ),
        child: ListView(
          children: [
            StreamBuilder(
                stream: _ble.scanForDevices(withServices: []),
                builder: (BuildContext context,
                    AsyncSnapshot<DiscoveredDevice> snapshot) {
                  if (snapshot.hasData) {
                    return buildList(scrWidth, scrHeight, snapshot.data);
                  }
                  return const CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
