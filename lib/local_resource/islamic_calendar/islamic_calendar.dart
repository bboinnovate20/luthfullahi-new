import 'dart:convert';

import 'package:babaloworo/shared/json_converter.dart';
import 'package:flutter/services.dart';

class IslamicCalendarUtil {
  getListOfHoliday() async {
    final List getJsonList =
        await loadJSONFile("assets/resources/islamic_holiday/islamic.json");

    return getJsonList.toList();
  }
}
