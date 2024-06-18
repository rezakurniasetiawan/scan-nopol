import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scan_nopol/homepage.dart';
import 'package:scan_nopol/model/vehicle.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(VehicleAdapter());
  await Hive.openBox<Vehicle>('vehicles');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
