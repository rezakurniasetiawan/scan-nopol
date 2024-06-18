// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 0;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      nopol: fields[0] as String,
      unit: fields[1] as String,
      finance: fields[2] as String,
      cabang: fields[3] as String,
      noRangka: fields[4] as String,
      noMesin: fields[5] as String,
      tahun: fields[6] as int,
      warna: fields[7] as String,
      overdue: fields[8] as int,
      saldo: fields[9] as int,
      nama: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.nopol)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.finance)
      ..writeByte(3)
      ..write(obj.cabang)
      ..writeByte(4)
      ..write(obj.noRangka)
      ..writeByte(5)
      ..write(obj.noMesin)
      ..writeByte(6)
      ..write(obj.tahun)
      ..writeByte(7)
      ..write(obj.warna)
      ..writeByte(8)
      ..write(obj.overdue)
      ..writeByte(9)
      ..write(obj.saldo)
      ..writeByte(10)
      ..write(obj.nama);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
