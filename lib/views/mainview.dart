import 'package:flutter/material.dart';
import 'package:isotech_smart_car_app/font/CustomIcon.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

// 38:81:D7:2D:65:CD
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final _flutterBlueClassicPlugin = FlutterBlueClassic();
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  StreamSubscription? _adapterStateSubscription;
  StreamSubscription? _scanSubscription;

  StreamSubscription? _scanningStateSubscription;
  final Set<BluetoothDevice> _scanResults = {};
  Future<void> initPlatformState() async {
    BluetoothAdapterState adapterState = _adapterState;

    try {
      adapterState = await _flutterBlueClassicPlugin.adapterStateNow;
      _adapterStateSubscription =
          _flutterBlueClassicPlugin.adapterState.listen((current) {
        if (mounted) setState(() => _adapterState = current);
      });
      _scanSubscription =
          _flutterBlueClassicPlugin.scanResults.listen((device) {
        if (mounted) setState(() => _scanResults.add(device));
      });
    } catch (e) {
      debugPrint('Error:');
      if (kDebugMode) print(e);
    }

    if (!mounted) return;

    setState(() {
      _adapterState = adapterState;
    });
  }

  void _debugB() async {
    var supported = await _flutterBlueClassicPlugin.isEnabled;
    var isScanningNow = await _flutterBlueClassicPlugin.isScanningNow;
    var adapterStateNow = await _flutterBlueClassicPlugin.adapterStateNow;
    debugPrint("Is supported: $supported");
    debugPrint("Is scanning: $isScanningNow");
    debugPrint(adapterStateNow.toString());
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _flutterBlueClassicPlugin.startScan();
    _debugB();
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
                        List<BluetoothDevice> scanResults =
                            _scanResults.toList();
                        debugPrint(
                            "Result: ${scanResults.toList().toString()}");
                        _flutterBlueClassicPlugin.startScan();
                        var isScanningNow =
                            await _flutterBlueClassicPlugin.isScanningNow;
                        debugPrint("Is scanning: $isScanningNow");
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
