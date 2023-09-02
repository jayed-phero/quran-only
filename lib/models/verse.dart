// To parse this JSON data, do
//
//     final suraAyays = suraAyaysFromJson(jsonString);

import 'dart:convert';

SuraAyays suraAyaysFromJson(String str) => SuraAyays.fromJson(json.decode(str));

String suraAyaysToJson(SuraAyays data) => json.encode(data.toJson());

class SuraAyays {
  int id;
  String name;
  String transliteration;
  String translation;
  String type;
  int totalVerses;
  List<Verse> verses;

  SuraAyays({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.translation,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });

  factory SuraAyays.fromJson(Map<String, dynamic> json) => SuraAyays(
        id: json["id"],
        name: json["name"],
        transliteration: json["transliteration"],
        translation: json["translation"],
        type: json["type"],
        totalVerses: json["total_verses"],
        verses: List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "transliteration": transliteration,
        "translation": translation,
        "type": type,
        "total_verses": totalVerses,
        "verses": List<dynamic>.from(verses.map((x) => x.toJson())),
      };
}

class Verse {
  int id;
  String text;
  String translation;
  String transliteration;

  Verse({
    required this.id,
    required this.text,
    required this.translation,
    required this.transliteration,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        id: json["id"],
        text: json["text"],
        translation: json["translation"],
        transliteration: json["transliteration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "translation": translation,
        "transliteration": transliteration,
      };
}
