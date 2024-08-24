import 'package:flutter/material.dart';
import 'package:isotech_smart_car_app/views/mainview.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return MaterialApp(
      title: 'Car Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffdc3545)),
        useMaterial3: true,
        buttonTheme: const ButtonThemeData(minWidth: 80, height: 80),
      ),
      home: const MainView(),
    );
  }
}
