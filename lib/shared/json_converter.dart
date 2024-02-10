import 'dart:convert';

import 'package:flutter/services.dart';

Future<dynamic> loadJSONFile(String filePath) async {
  final data = await rootBundle.loadString(filePath);
  return json.decode(data);
}
