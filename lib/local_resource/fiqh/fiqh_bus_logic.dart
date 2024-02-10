import 'dart:convert';

import 'package:flutter/services.dart';

class FiqhUtil {
  getFiqhList() async {
    final List getJsonList =
        await loadJSONFile("assets/resources/fiqh/fiqh_list.json");
    return getJsonList.toList();
  }

  getSingleFiqListing(int id) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/fiqh/fiqh_list.json");
    return getJsonList.where((element) => element['id'] == id).first;
  }

  getMainContent(int listId, int mainId) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/fiqh/main_fiqh.json");

    final result = getJsonList
        .where((element) => element['level'] == listId)
        .first['subtopic'];

    // print(mainId);
    return result.where((element) => element['id'] == mainId).first['content'];
  }

  Future<dynamic> loadJSONFile(String filePath) async {
    final data = await rootBundle.loadString(filePath);
    return json.decode(data);
  }
}
