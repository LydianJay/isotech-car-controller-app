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

  @override
  void initState() {
    super.initState();
    _scanSub = _ble.scanForDevices(withServices: []).listen(_onScanUpdate);
  }

  void _onScanUpdate(DiscoveredDevice d) {
    debugPrint(d.name);
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
                      onPressed: () async {},
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
