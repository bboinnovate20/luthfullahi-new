import 'dart:convert';

import 'package:flutter/services.dart';

class DuaUtil {
  getDuaList() async {
    final List getJsonList =
        await loadJSONFile("assets/resources/dua/dua_listing.json");
    return getJsonList.toList();
  }

  filterList(String value) async {
    final List getJsonList = await loadJSONFile(
        "assets/resources/dua/dua_listing_and_sub_list.json");

    final theList = getJsonList.toList();

    final filteredList = theList
        .map((element) {
          final filteredListing = element['listing']
              .where(
                  (element_) => (element_['content'] as String).contains(value))
              .toList();

          if (element['name'].contains(value) || filteredListing.isNotEmpty) {
            return {
              ...element,
              'listing': filteredListing,
            };
          }

          return null;
        })
        .where((element) => element != null)
        .toList();

    return filteredList;
  }

  duaListing(int id) async {
    final List getJsonList = await loadJSONFile(
        "assets/resources/dua/dua_listing_and_sub_list.json");

    return getJsonList.where((element) => element['id'] == id).first;
  }

  duaMainListing(int listId) async {
    final List getJsonList =
        await loadJSONFile("assets/resources/dua/dua_main.json");
    final resultOne =
        getJsonList.where((element) => element['id'] == listId).first;

    return resultOne['content'];
  }

  Future<dynamic> loadJSONFile(String filePath) async {
    final data = await rootBundle.loadString(filePath);
    return json.decode(data);
  }
}
