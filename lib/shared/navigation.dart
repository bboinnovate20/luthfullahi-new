import 'package:babaloworo/calendar/calendar.dart';
import 'package:babaloworo/chat/chat.dart';
import 'package:babaloworo/dashboard/dashboard.dart';
import 'package:babaloworo/dua/dua_widget.dart';
import 'package:babaloworo/fiqh/fiqh_widget.dart';
import 'package:babaloworo/hadith/hadith_widget.dart';
import 'package:babaloworo/luthfullahi/luthfullahi_main_content.dart';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/media/media.dart';
import 'package:babaloworo/notification/notification.dart';
import 'package:babaloworo/prayer_time/prayer_time.dart';
import 'package:babaloworo/profile/identity_card.dart';
import 'package:babaloworo/qibla/qibla.dart';
import 'package:babaloworo/quran/quran_reading_widget.dart';
import 'package:babaloworo/quran/quran_widget.dart';
import 'package:babaloworo/tesbih/tesbih.dart';

class NavigatorNamed {
  static Dashboard home = const Dashboard();
  static String firstTime = "first_time_auth";
  static QuranReading surahReading({index = 1, verse = -1, reciterId = 1}) =>
      QuranReading(id: index, verse: verse, reciter: reciterId);
  static Quran quran({isWithBackButton = false}) =>
      Quran(isWithBackButton: isWithBackButton);
  static IdentityCard idCardView({name = "", status = "MEMBER"}) =>
      IdentityCard(name: name, status: status);

  // hadith
  static Hadith mainHadith({isWithBackButton = false}) =>
      Hadith(isWithBackButton: isWithBackButton);
  static EachHadithList specificHadithList({bookId = 1}) =>
      EachHadithList(bookId: bookId);
  static MainHadithContent mainHadithContent(
          {bookId, collection, title, author}) =>
      MainHadithContent(
          bookId: bookId, collection: collection, title: title, author: author);

  // fiqh
  static Fiqh fiqh = const Fiqh();
  static FiqhEachList fiqhListing({int id = 1, String title = ""}) =>
      FiqhEachList(id: id, title: title);
  static MainFiqhContent fiqhMainListing(
          {int listId = 1, int mainId = 1, String title = ""}) =>
      MainFiqhContent(listId: listId, mainId: mainId, parentTitle: title);

  //dua
  static Dua dua = const Dua();
  static DuaEachList duaListing({int id = 1, String title = ""}) =>
      DuaEachList(id: id, title: title);
  static DuaMain duaMainListing(
          {int listId = 1,
          int mainId = 1,
          String title = "",
          String subtitle = ""}) =>
      DuaMain(listId: listId, mainId: mainId, subtitle: subtitle, title: title);

  //other-feature
  static IslamicCalendar calendar = const IslamicCalendar();
  static Tesbih tesbih = const Tesbih();
  static Qibla qibla = const Qibla();
  static Media media = const Media();

  //chat
  static Chat chat = const Chat();

  //notification
  static NotificationScreen notification = const NotificationScreen();

  //solat
  static PrayerTime prayerTime = const PrayerTime();

  //luthfullahi
  static LuthfullahiList luthfullahi = const LuthfullahiList();
  static LuthfullahiMain luthfullahiMain({id = 1}) =>
      LuthfullahiMain(initialIndex: id);
}
