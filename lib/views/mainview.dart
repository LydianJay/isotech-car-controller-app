import 'package:flutter/material.dart';
import 'package:isotech_smart_car_app/font/CustomIcon.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

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
  List<DiscoveredDevice> discoveredDevices = [];

  String? id;
  Uuid? serviceId;
  Uuid? charId;

  int armState = 0;
  @override
  void initState() {
    super.initState();
    _scanSub = _ble.scanForDevices(withServices: []).listen(_onScanUpdate);
  }

  void _onScanUpdate(DiscoveredDevice d) {
    if (!discoveredDevices.contains(d)) {
      setState(() {
        discoveredDevices.add(d);
      });
    }
  }

  /* 
    _connectSub = _ble.connectToDevice(id: d.id).listen((update) {
      if (update.connectionState == DeviceConnectionState.connected) {
        setState(() {});
        id = d.id;
        serviceId = d.serviceUuids.first;
        charId = d.serviceUuids[1];

        for (var ids in d.serviceUuids) {
          debugPrint("id: ${ids.toString()}");
        }

        debugPrint('Connected!');
      }
    });
    */

  Widget buildList(double scrWidth, double scrHeight) {
    final List<Widget> list = [];

    for (var d in discoveredDevices) {
      list.add(Container(
        width: scrWidth,
        height: scrHeight * 0.15,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          children: [
            Text("Device name: ${d.id}"),
            Text("Device service ID: ${d.serviceUuids.first.toString()}"),
            Text("Device characteristic ID: ${d.serviceUuids[1].toString()}"),
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
    return ListView(
      children: [
        buildList(scrWidth, scrHeight),
      ],
    );
  }
}
