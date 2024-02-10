import 'package:share_plus/share_plus.dart';

shareContent(
    {String arabic = "",
    String english = "",
    String transliteration = "",
    String type = "Quran"}) {
  String bottomTemplate = "Luthfullahi | Babaloworo App";
  String content =
      "$arabic \n $transliteration \n -------------- \n $english \n  \n $bottomTemplate";

  Share.share(content, subject: "Luthfullahi $type Quote");
}
