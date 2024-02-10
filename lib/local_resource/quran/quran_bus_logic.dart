import 'dart:convert';

import 'package:flutter/services.dart';

class QuranUtil {
  Future<List<QuranList>> getOnlySurah() async {
    final List getJsonList =
        await loadJSONFile("assets/resources/quran/quran_index.json");
    List<QuranList> resultList = getJsonList
        .map((verse) => QuranList(
            verse: verse['surahId'],
            arabic: verse['surahTransliteration'],
            english: verse['surahMeaning']))
        .toList();
    return resultList;
  }

  Future<Map> getSurahName(int id) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/quran/quran_index.json");
    final resultList =
        getJsonList.where((element) => element["surahId"] == id).first;

    return resultList;
  }

  Future<List> getSurah(id) async {
    final List loadArabic =
        await loadJSONFile("assets/resources/quran/quran.json");
    final List loadEnglish =
        await loadJSONFile("assets/resources/quran/quran_translation.json");

    final List loadTransliteration =
        await loadJSONFile("assets/resources/quran/quran_transliteration.json");

    final List englishTranslate =
        loadEnglish.where((element) => element['surah'] == id).toList();

    final List englishTransliterate =
        loadTransliteration.where((element) => element['surah'] == id).toList();

    final result = loadArabic[id - 1];

    Map<String, String> meta = {
      "transliteration": result['transliteration'],
      "totalVerse": result['total_verses'].toString()
    };

    final List versesInstance = result['verses']
        .map((verse) => QuranVerse(
            arabic: verse['text'],
            translation: englishTranslate[verse['id'] - 1]['translation'],
            transliteration: englishTransliterate[verse['id'] - 1]
                ['transliteration'],
            verse: verse['id']))
        .toList();

    return [meta, versesInstance];
  }

  Future<dynamic> loadJSONFile(String filePath) async {
    final data = await rootBundle.loadString(filePath);
    return json.decode(data);
  }
}

class QuranList {
  final int verse;
  final String arabic;
  final String english;
  QuranList({required this.verse, required this.arabic, required this.english});
}

class QuranVerse {
  final int verse;
  final String arabic;
  final String? translation;
  final String? transliteration;

  QuranVerse(
      {required this.verse,
      required this.arabic,
      this.translation,
      this.transliteration});
}
