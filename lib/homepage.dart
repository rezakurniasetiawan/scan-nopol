import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:io';

import 'package:scan_nopol/model/vehicle.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _progress = 0.0;
  String _duration = '00:00:00';
  List<Vehicle> _searchResults = [];
  List<Vehicle> _importedData = [];
  final TextEditingController _searchController = TextEditingController();
  int _totalData = 0;
  int _boxSize = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> importCsvToHive() async {
    final box = Hive.box<Vehicle>('vehicles');
    final rawData = await rootBundle.loadString('assets/Nopol.csv');
    // Filename in asset Boox1 (adalah data csv kecil)
    // Filename in asset budi (adalah data csv hasil convert google collab)
    // Filename in asset Nopol (adalah data csv asli export dari excel)
    List<List<dynamic>> data = const CsvToListConverter().convert(rawData);

    int totalRows = data.length - 1;
    int processedRows = 0;
    Stopwatch stopwatch = Stopwatch()..start();

    for (var i = 1; i < data.length; i++) {
      final row = data[i];
      final vehicle = Vehicle(
        nopol: row[0] as String,
        unit: row[1] as String,
        finance: row[2] as String,
        cabang: row[3] as String,
        noRangka: row[4] as String,
        noMesin: row[5] as String,
        tahun: row[6] as int,
        warna: row[7] as String,
        overdue: row[8] as int,
        saldo: row[9] as int,
        nama: row[10] as String,
      );
      box.add(vehicle);
      print(vehicle.nopol);

      processedRows++;
      setState(() {
        _progress = processedRows / totalRows;
        _duration = stopwatch.elapsed.toString().split('.').first;
        _totalData = box.length; 
        _boxSize = _getBoxSize(box);
      });
    }

    stopwatch.stop();
  }

  Future<void> searchVehicleByNopol(String nopol) async {
    final box = Hive.box<Vehicle>('vehicles');
    final results = box.values.where((vehicle) => vehicle.nopol.contains(nopol)).toList();
    print(results);
    setState(() {
      _searchResults = results.cast<Vehicle>();
    });
  }

  int _getBoxSize(Box box) {
    final file = File(box.path!);
    return file.existsSync() ? file.lengthSync() : 0;
  }


  Future<void> deleteHive() async {
    final box = Hive.box<Vehicle>('vehicles');
    await box.clear();
    setState(() {
      _totalData = 0;
      _boxSize = _getBoxSize(box);
      _progress = 0.0;
      _duration = '00:00:00';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import CSV to Hive'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await importCsvToHive();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data imported successfully')),
                );
              },
              child: const Text('Import CSV'),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteHive();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data deleted successfully')),
                );
              },
              child: const Text('Delete Hive'),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 10),
            Text('Progress: ${(_progress * 100).toStringAsFixed(2)}%'),
            const SizedBox(height: 10),
            Text('Duration: $_duration'),
            const SizedBox(height: 20),
            Text('Total Data: $_totalData'),
            const SizedBox(height: 10),
            Text('Memory Size: ${(_boxSize / (1024 * 1024)).toStringAsFixed(2)} MB'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  searchVehicleByNopol(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search by Nopol',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      searchVehicleByNopol(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.isNotEmpty ? _searchResults.length : _importedData.length,
                itemBuilder: (context, index) {
                  final vehicle = _searchResults.isNotEmpty ? _searchResults[index] : _importedData[index];
                  return ListTile(
                    title: Text(vehicle.nopol),
                    subtitle: Text('Nama: ${vehicle.nama}, Saldo: ${vehicle.saldo}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
