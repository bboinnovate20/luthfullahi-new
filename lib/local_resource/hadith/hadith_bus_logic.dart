import 'dart:convert';

import 'package:flutter/services.dart';

class HadithUtil {
  getHadithList() async {
    final List getJsonList =
        await loadJSONFile("assets/resources/hadiths/hadith_books.json");

    return getJsonList;
  }

  getBookForSingleHadith(int id) async {
    final List getJsonList = await loadJSONFile(
        "assets/resources/hadiths/each_book_for_collection.json");

    return getJsonList.where((element) => element['id'] == id).first;
  }

  getMainContent(int book, String collection) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/hadiths/hadith_main_content.json");

    return getJsonList
        .where((element) =>
            element['collection'] == collection && element['book'] == book)
        .first;
  }

  getCollection(int id) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/hadiths/hadith_books.json");

    return getJsonList.where((element) => element['id'] == id).first;
  }

  Future<Map> getSurahName(int id) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/quran/quran_index.json");
    final resultList =
        getJsonList.where((element) => element["surahId"] == id).first;

    return resultList;
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
