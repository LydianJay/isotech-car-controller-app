import 'package:flutter/material.dart';
import 'package:isotech_smart_car_app/font/CustomIcon.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';

class ControllerView extends StatefulWidget {
  final String ipAdd;
  final int port;

  const ControllerView({
    super.key,
    required this.ipAdd,
    required this.port,
  });

  @override
  State<ControllerView> createState() => _ControllerViewState();
}

class _ControllerViewState extends State<ControllerView> {
  int armState = 0;
  Socket? socket;

  void _sendBytes(List<int> data) async {
    if (socket != null) {
      socket!.add(data);
      // socket!.write(data);
      // debugPrint(data.toString());
      // debugPrint('SEnding data');
      // await socket!.flush();
    } else {
      debugPrint('Socket is null');
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    connectToDevice();
  }

  void connectToDevice() async {
    try {
      debugPrint("Connecting to ${widget.ipAdd} PORT: ${widget.port}");
      socket = await Socket.connect(widget.ipAdd, widget.port);
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pop(context);
    }
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
            width: scrHeight * 0.83,
            height: scrHeight * 0.83,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filled(
                  onPressed: () {},
                  icon: GestureDetector(
                    onTapDown: (details) {
                      debugPrint('tap');
                      int tiltState = 4;

                      final List<int> data = [tiltState, 0];
                      _sendBytes(data);
                    },
                    onTapUp: (details) {
                      debugPrint('released');
                      _sendBytes([0, 0]);
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
                          final List<int> data = [2, 0];
                          _sendBytes(data);
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes([0, 0]);
                        },
                        child: const Icon(CustomIcon.rotate_left),
                      ),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () async {
                        armState == 16 ? armState = 0 : armState = 16;
                        _sendBytes([16, 0]);
                      },
                      icon: const Icon(CustomIcon.robot_arm),
                      iconSize: 50,
                    ),
                    IconButton.filled(
                      onPressed: () {},
                      icon: GestureDetector(
                        onTapDown: (details) {
                          debugPrint('tap');
                          final List<int> data = [1, 0];
                          _sendBytes(data);
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes([0, 0]);
                        },
                        child: const Icon(CustomIcon.rotate_right),
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
                      int tiltState = 8;

                      final List<int> data = [tiltState, 0];
                      _sendBytes(data);
                    },
                    onTapUp: (details) {
                      debugPrint('released');
                      _sendBytes([0, 0]);
                    },
                    child: const Icon(Icons.arrow_downward),
                  ),
                  iconSize: 50,
                ),
              ],
            ),
          ),
          SizedBox(
            width: scrWidth * 0.15,
            height: scrHeight,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: IconButton.filled(
                    onPressed: () async {
                      await SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown,
                      ]);
                      // await widget.connectSub!.cancel();
                      // Navigator.pop(context);
                    },
                    icon: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: scrHeight * 0.9,
            height: scrHeight * 0.9,
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
                        final List<int> data = [0, 163];
                        _sendBytes(data);
                      },
                      onTapUp: (details) {
                        debugPrint('released');
                        _sendBytes([0, 0]);
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
                          final List<int> data = [0, 83];
                          _sendBytes(data);
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes([0, 0]);
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
                          final List<int> data = [0, 172];
                          _sendBytes(data);
                        },
                        onTapUp: (details) {
                          debugPrint('released');
                          _sendBytes([0, 0]);
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
                        final List<int> data = [0, 92];
                        _sendBytes(data);
                      },
                      onTapUp: (details) {
                        debugPrint('released');
                        _sendBytes([0, 0]);
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
