// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaAdapter extends TypeAdapter<Manga> {
  @override
  final int typeId = 0;

  @override
  Manga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manga(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    )
      .._author = fields[6] as String?
      .._year = fields[7] as String?
      .._genres = (fields[8] as List?)?.cast<String>()
      .._chapters = (fields[9] as List?)?.cast<Chapter>();
  }

  @override
  void write(BinaryWriter writer, Manga obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj._title)
      ..writeByte(1)
      ..write(obj._url)
      ..writeByte(2)
      ..write(obj._imageUrl)
      ..writeByte(3)
      ..write(obj._chapter)
      ..writeByte(4)
      ..write(obj._views)
      ..writeByte(5)
      ..write(obj._description)
      ..writeByte(6)
      ..write(obj._author)
      ..writeByte(7)
      ..write(obj._year)
      ..writeByte(8)
      ..write(obj._genres)
      ..writeByte(9)
      ..write(obj._chapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MangaStorageAdapter extends TypeAdapter<MangaStorage> {
  @override
  final int typeId = 2;

  @override
  MangaStorage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MangaStorage(
      fields[0] as Manga,
      (fields[1] as List).cast<String>(),
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MangaStorage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._manga)
      ..writeByte(1)
      ..write(obj._mangaImages)
      ..writeByte(2)
      ..write(obj._currentPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaStorageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChapterAdapter extends TypeAdapter<Chapter> {
  @override
  final int typeId = 1;

  @override
  Chapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chapter(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Chapter obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._title)
      ..writeByte(1)
      ..write(obj._url)
      ..writeByte(2)
      ..write(obj._date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
