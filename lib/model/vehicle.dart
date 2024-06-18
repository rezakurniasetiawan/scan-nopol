import 'package:hive/hive.dart';

part 'vehicle.g.dart';

@HiveType(typeId: 0)
class Vehicle {
  @HiveField(0)
  late String nopol;

  @HiveField(1)
  late String unit;

  @HiveField(2)
  late String finance;

  @HiveField(3)
  late String cabang;

  @HiveField(4)
  late String noRangka;

  @HiveField(5)
  late String noMesin;

  @HiveField(6)
  late int tahun;

  @HiveField(7)
  late String warna;

  @HiveField(8)
  late int overdue;

  @HiveField(9)
  late int saldo;

  @HiveField(10)
  late String nama;

  Vehicle({
    required this.nopol,
    required this.unit,
    required this.finance,
    required this.cabang,
    required this.noRangka,
    required this.noMesin,
    required this.tahun,
    required this.warna,
    required this.overdue,
    required this.saldo,
    required this.nama,
  });
}
