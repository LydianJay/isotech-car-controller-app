import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:isotech_smart_car_app/font/CustomIcon.dart';
import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// 38:81:D7:2D:65:CD
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

  bool isFound = false;
  bool isConnected = false;
  String? id = null;
  Uuid? serviceId = null;
  Uuid? charId = null;

  int armState = 0;

  @override
  void initState() {
    super.initState();
    _scanSub = _ble.scanForDevices(withServices: []).listen(_onScanUpdate);
  }

  void _onScanUpdate(DiscoveredDevice d) {
    if (d.name == "BT05" && !isFound) {
      isFound = true;

      debugPrint("service ID: ${d.serviceUuids.first.toString()} ");
      debugPrint("ID: ${d.id} ");
      _connectSub = _ble.connectToDevice(id: d.id).listen((update) {
        if (update.connectionState == DeviceConnectionState.connected) {
          // _onConnected(d.id, d.serviceUuids.first);
          isConnected = true;
          id = d.id;
          serviceId = d.serviceUuids.first;
          charId = d.serviceUuids[1];

          for (var ids in d.serviceUuids) {
            debugPrint("id: ${ids.toString()}");
          }

          debugPrint('Connected!');
        }
      });
    }
  }

  void _sendBytes(String id, Uuid serviceID, Uuid charID) {
    final characteristic = QualifiedCharacteristic(
      deviceId: id,
      characteristicId: charID,
      serviceId: serviceID,
    );

    _ble.writeCharacteristicWithoutResponse(characteristic,
        value: [armState, 0x00]).onError((E, s) {
      debugPrint("Error Occured: ${E.toString()}");
      debugPrintStack(stackTrace: s);
    });
    armState == 16 ? armState = 0 : armState = 16;
  }

  // void _onConnected(String deviceId) {
  //   final characteristic = QualifiedCharacteristic(
  //       deviceId: deviceId,
  //       serviceId: Uuid.parse('00000000-5EC4-4083-81CD-A10B8D5CF6EC'),
  //       characteristicId: Uuid.parse('00000001-5EC4-4083-81CD-A10B8D5CF6EC'));
  //   _notifySub = _ble.subscribeToCharacteristic(characteristic).listen((bytes) {
  //     setState(() {
  //       _value = const Utf8Decoder().convert(bytes);
  //     });
  //   });
  // }

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
    return Container(
      width: scrWidth,
      height: scrHeight,
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          SizedBox(
            width: scrHeight,
            height: scrHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_upward),
                  iconSize: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        if (isConnected) {
                          _sendBytes(id!, serviceId!, charId!);
                        } else {
                          debugPrint('Not connected!');
                        }
                      },
                      icon: const Icon(CustomIcon.robot_arm),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward),
                      iconSize: 50,
                    ),
                  ],
                ),
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 50,
                ),
              ],
            ),
          ),
          SizedBox(
            width: scrWidth / 3.0,
            height: scrHeight,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
