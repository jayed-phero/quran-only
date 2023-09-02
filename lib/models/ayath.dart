import 'dart:convert';
import 'package:flutter/services.dart';

class Ayat {
  int id;
  int sura;
  int verseIDAr;
  String ayat;

  Ayat(
      {required this.id,
      required this.sura,
      required this.verseIDAr,
      required this.ayat});

  // Create a factory constructor to deserialize the JSON data
  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      id: int.parse(json['id']),
      sura: int.parse(json['sura']),
      verseIDAr: int.parse(json['VerseIDAr']),
      ayat: json['ayat'],
    );
  }
}

class AyatEnglish {
  int id;
  int sura;
  int aya;
  String text;

  AyatEnglish(
      {required this.id,
      required this.sura,
      required this.aya,
      required this.text});

  factory AyatEnglish.fromJson(Map<String, dynamic> json) {
    return AyatEnglish(
      id: int.parse(json['id']),
      sura: int.parse(json['sura']),
      aya: int.parse(json['aya']),
      text: json['text'],
    );
  }
}

class AyatBangla {
  int id;
  int sura;
  int aya;
  String text;

  AyatBangla(
      {required this.id,
      required this.sura,
      required this.aya,
      required this.text});

  factory AyatBangla.fromJson(Map<String, dynamic> json) {
    return AyatBangla(
      id: int.parse(json['id']),
      sura: int.parse(json['sura']),
      aya: int.parse(json['aya']),
      text: json['text'],
    );
  }
}

class AyatDetail {
  int verseIDAr;
  String ayatArabic;
  String ayatEnglish;
  String ayatBangla;

  AyatDetail({
    required this.verseIDAr,
    required this.ayatArabic,
    required this.ayatEnglish,
    required this.ayatBangla,
  });
}

// Load and Deserialize JSON Data
Future<List<Ayat>> _loadArabicAyatData() async {
  String arabicData =
      await rootBundle.loadString('assets/datas/arabic_ayat.json');
  List<dynamic> arabicJson = json.decode(arabicData);
  List<Ayat> arabicAyats =
      arabicJson.map((json) => Ayat.fromJson(json)).toList();
  return arabicAyats;
}

Future<List<AyatEnglish>> _loadEnglishAyatData() async {
  String englishData =
      await rootBundle.loadString('assets/datas/english_ayat.json');
  List<dynamic> englishJson = json.decode(englishData);
  List<AyatEnglish> englishAyats =
      englishJson.map((json) => AyatEnglish.fromJson(json)).toList();
  return englishAyats;
}

Future<List<AyatBangla>> _loadBanglaAyatData() async {
  String banglaData =
      await rootBundle.loadString('assets/datas/bangla_ayat.json');
  List<dynamic> banglaJson = json.decode(banglaData);
  List<AyatBangla> banglaAyats =
      banglaJson.map((json) => AyatBangla.fromJson(json)).toList();
  return banglaAyats;
}

// Combine Data and Get Sura Details
Future<List<AyatDetail>> getSuraDetails(int suraNumber) async {
  List<Ayat> arabicAyats = await _loadArabicAyatData();
  List<AyatEnglish> englishAyats = await _loadEnglishAyatData();
  List<AyatBangla> banglaAyats = await _loadBanglaAyatData();

  List<AyatDetail> suraDetails = [];

  for (int i = 0; i < arabicAyats.length; i++) {
    if (arabicAyats[i].sura == suraNumber) {
      suraDetails.add(AyatDetail(
        verseIDAr: arabicAyats[i].verseIDAr,
        ayatArabic: arabicAyats[i].ayat,
        ayatEnglish: englishAyats[i].text,
        ayatBangla: banglaAyats[i].text,
      ));
    }
  }

  return suraDetails;
}
