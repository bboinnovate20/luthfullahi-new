import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DownloadSurah {
  // int surahId = 1;
  // int verseId = 1;
  // String reciterName = "AbdulSamad";

  Future getDirectoryPath() async {
    String directory = "Babaloworo";

    Directory path = await getApplicationDocumentsDirectory();

    String localPath = '${path.path}${Platform.pathSeparator}$directory';
    final savedDir = Directory(localPath);

    if (await savedDir.exists()) {
      return localPath;
    } else {
      savedDir.create();
      return localPath;
    }
  }

  savedIntoDirector(
      int surahId, int verse, String reciterName, uri, path) async {
    HttpClient httpClient = HttpClient();

    try {
      final filePath = '$path/${reciterName}s_${surahId}_$verse.mp3';
      final myFile = File(filePath);
      if (await myFile.exists()) {
        return myFile.path.toString();
      } else {
        var request = await httpClient.getUrl(Uri.parse(uri));
        var response = await request.close();
        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);

          await myFile.writeAsBytes(bytes);
          return myFile.path.toString();
        }
      }
    } catch (e) {
      return "false";
    }
  }
}
