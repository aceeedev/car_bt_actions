// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bt_button.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BTButtonAdapter extends TypeAdapter<BTButton> {
  @override
  final int typeId = 3;

  @override
  BTButton read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BTButton(
      buttonID: fields[0] as String,
      buttonActions: (fields[1] as List).cast<ButtonAction>(),
    );
  }

  @override
  void write(BinaryWriter writer, BTButton obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.buttonID)
      ..writeByte(1)
      ..write(obj.buttonActions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BTButtonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
