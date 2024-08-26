import 'package:flutter/material.dart';
import 'package:isotech_smart_car_app/views/developerinfo.dart';
import 'package:isotech_smart_car_app/views/mainview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Controller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffdc3545)),
        useMaterial3: true,
        buttonTheme: const ButtonThemeData(minWidth: 80, height: 80),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color(0xffffc107),
            ),
            foregroundColor: WidgetStatePropertyAll(Color(0xff4f0e11)),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Color(0xffdc3545),
                fontFamily: 'Calibre',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xffdc3545),
          titleTextStyle: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Calibre',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Calibre',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        '/mainview': (context) => const MainView(),
        '/devinfoview': (context) => const DeveloperInfoView(),
      },
      initialRoute: '/mainview',
    );
  }
}
