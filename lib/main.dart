import 'package:flutter/material.dart';
import 'package:quran_only/home_screen.dart';
import 'package:quran_only/quran.dart';

void main() async {
  runApp(const MyApp());
}

void quranData() {
  dynamic suraFathiha = quran['1'];
}

void someFunction() {
  print(quran["1"]["name"]); // Output: سُورَةُ ٱلْفَاتِحَةِ
  print(quran["1"]["ayahs"][0]
      ["textArabic"]); // Output: ﻿بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
