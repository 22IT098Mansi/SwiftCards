// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoyaltyCardAdapter extends TypeAdapter<LoyaltyCard> {
  @override
  final int typeId = 0;

  @override
  LoyaltyCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoyaltyCard(
      id: fields[0] as String,
      name: fields[1] as String,
      cardNumber: fields[2] as String,
      expiryDate: fields[3] as DateTime,
      barcodeValue: fields[4] as String,
      logoPath: fields[5] as String?,
      isSynced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LoyaltyCard obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cardNumber)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.barcodeValue)
      ..writeByte(5)
      ..write(obj.logoPath)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
