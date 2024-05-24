import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transport_system/firebase_options.dart';
import 'package:transport_system/auth/login.dart';
import 'package:transport_system/driver/driver_home.dart';
import 'package:transport_system/driver/update_alerts.dart';
import 'package:transport_system/driver/view_route.dart';
import 'package:transport_system/driver/view_time_location.dart';
import 'package:transport_system/driver/driver_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/driver_home': (context) => DriverHome(),
        '/update_alerts': (context) => UpdateAlerts(),
        '/view_route': (context) => ViewRoute(),
        '/view_time_location': (context) => ViewTimeLocation(),
        '/driver_profile': (context) => DriverProfile(),
      },
    );
  }
}
