// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ButtonActionAdapter extends TypeAdapter<ButtonAction> {
  @override
  final int typeId = 2;

  @override
  ButtonAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ButtonAction(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ButtonAction obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.actionName)
      ..writeByte(1)
      ..write(obj.actionParameters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButtonActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
