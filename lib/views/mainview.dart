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

  bool isFound = false;
  bool isConnected = false;
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
    if (d.name == "BT05" && !isFound) {
      isFound = true;

      debugPrint("service ID: ${d.serviceUuids.first.toString()} ");
      debugPrint("ID: ${d.id} ");
      _connectSub = _ble.connectToDevice(id: d.id).listen((update) {
        if (update.connectionState == DeviceConnectionState.connected) {
          setState(() {
            isConnected = true;
          });
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

  void _sendBytes(String id, Uuid serviceID, Uuid charID, List<int> data) {
    final characteristic = QualifiedCharacteristic(
      deviceId: id,
      characteristicId: charID,
      serviceId: serviceID,
    );
    data.first |= armState;
    _ble
        .writeCharacteristicWithoutResponse(characteristic, value: data)
        .onError((E, s) {
      debugPrint("Error Occured: ${E.toString()}");
      debugPrintStack(stackTrace: s);
    });
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
            width: scrHeight * 0.85,
            height: scrHeight * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(
                  onPressed: () {},
                  icon: GestureDetector(
                    onTapDown: (details) {
                      debugPrint('tap');
                      if (isConnected) {
                        int tiltState = 4;

                        final List<int> data = [tiltState, 0];
                        _sendBytes(id!, serviceId!, charId!, data);
                      } else {
                        debugPrint('Not connected!');
                      }
                    },
                    onTapUp: (details) {
                      debugPrint('released');
                      _sendBytes(id!, serviceId!, charId!, [0, 0]);
                    },
                    child: const Icon(Icons.arrow_upward),
                  ),
                  iconSize: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.filled(
                      onPressed: () {},
                      icon: GestureDetector(
                        onTapDown: (details) {
                          debugPrint('tap');
                          if (isConnected) {
                            final List<int> data = [2, 0];
                            _sendBytes(id!, serviceId!, charId!, data);
                          } else {
                            debugPrint('Not connected!');
                          }
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes(id!, serviceId!, charId!, [0, 0]);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        if (isConnected) {
                          armState == 16 ? armState = 0 : armState = 16;
                          _sendBytes(id!, serviceId!, charId!, [armState, 0]);
                        } else {
                          debugPrint('Not connected!');
                        }
                      },
                      icon: const Icon(CustomIcon.robot_arm),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () {},
                      icon: GestureDetector(
                        onTapDown: (details) {
                          debugPrint('tap');
                          if (isConnected) {
                            final List<int> data = [1, 0];
                            _sendBytes(id!, serviceId!, charId!, data);
                          } else {
                            debugPrint('Not connected!');
                          }
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes(id!, serviceId!, charId!, [0, 0]);
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                      iconSize: 50,
                    ),
                  ],
                ),
                IconButton.filled(
                  onPressed: () {},
                  icon: GestureDetector(
                    onTapDown: (details) {
                      debugPrint('tap');
                      if (isConnected) {
                        int tiltState = 8;

                        final List<int> data = [tiltState, 0];
                        _sendBytes(id!, serviceId!, charId!, data);
                      } else {
                        debugPrint('Not connected!');
                      }
                    },
                    onTapUp: (details) {
                      debugPrint('released');
                      _sendBytes(id!, serviceId!, charId!, [0, 0]);
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  iconSize: 50,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isConnected
                    ? Colors.green
                    : const Color.fromARGB(255, 255, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isConnected ? 'Connected' : 'Not connected',
                maxLines: 2,
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          SizedBox(
            width: scrHeight * 0.85,
            height: scrHeight * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: IconButton.filled(
                    onPressed: () {},
                    icon: GestureDetector(
                      onTapDown: (details) {
                        debugPrint('tap');
                        if (isConnected) {
                          final List<int> data = [0, 163];
                          _sendBytes(id!, serviceId!, charId!, data);
                        } else {
                          debugPrint('Not connected!');
                        }
                      },
                      onTapUp: (details) {
                        debugPrint('released');
                        _sendBytes(id!, serviceId!, charId!, [0, 0]);
                      },
                      child: const Icon(Icons.arrow_upward),
                    ),
                    iconSize: 50,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.filled(
                      onPressed: () {},
                      icon: GestureDetector(
                        onTapDown: (details) {
                          debugPrint('tap');
                          if (isConnected) {
                            final List<int> data = [0, 172];
                            _sendBytes(id!, serviceId!, charId!, data);
                          } else {
                            debugPrint('Not connected!');
                          }
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes(id!, serviceId!, charId!, [0, 0]);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () {},
                      icon: GestureDetector(
                        onTapDown: (details) {
                          debugPrint('tap');
                          if (isConnected) {
                            final List<int> data = [0, 83];
                            _sendBytes(id!, serviceId!, charId!, data);
                          } else {
                            debugPrint('Not connected!');
                          }
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes(id!, serviceId!, charId!, [0, 0]);
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                      iconSize: 50,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 45),
                  child: IconButton.filled(
                    onPressed: () {},
                    icon: GestureDetector(
                      onTapDown: (details) {
                        debugPrint('tap');
                        if (isConnected) {
                          final List<int> data = [0, 92];
                          _sendBytes(id!, serviceId!, charId!, data);
                        } else {
                          debugPrint('Not connected!');
                        }
                      },
                      onTapUp: (details) {
                        debugPrint('released');
                        _sendBytes(id!, serviceId!, charId!, [0, 0]);
                      },
                      child: const Icon(Icons.arrow_downward),
                    ),
                    iconSize: 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
