import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:babaloworo/prayer_time/prayer_time.dart';
import 'package:babaloworo/prayer_time/prayer_time_util.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationUtil {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  requestPermission() async {
    try {
      if (Platform.isAndroid) {
        bool? isPermitted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission();
        if (isPermitted != null) return isPermitted;
        return false;
      }

      return await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      return true;
    }
  }

  String getRandomVerse() {
    final List<String> salahVersesAndHadiths = [
      "Q2v43: Establish prayer, give zakah, bow with those who bow.",
      "Q2v153: Seek help through patience and prayer, Allah is with the patient.",
      "Q23v1-2: Believers who pray with solemnity are successful.",
      "Q2v238: Guard prayers, the middle prayer, stand devoutly obedient.",
      "Q2v45: Seek help through patience and prayer, it is difficult but for the humble.",
      "Abdullah ibn Shaqiq: First judgment on the Day of Resurrection is prayer.",
      "Abu Huraira: Five daily prayers blot out evil deeds.",
      "Anas ibn Malik: The coolness of my eyes is in the prayer.",
      "Abu Huraira: One who perfects prayer preserves life and property.",
      "Abdullah ibn Qais: Sins forgiven for the one who stands firm in prayers."
    ];

    final Random random = Random();
    final int randomIndex = random.nextInt(salahVersesAndHadiths.length);
    return salahVersesAndHadiths[randomIndex];
  }

  savedMutedAdhan(int adhanId) async {
    final storage = SecuredStorage();
    final getAdhan = await storage.readData(key: "adhan_muted");
    List mutedAdhan = [];
    if (getAdhan != null) {
      mutedAdhan = await jsonDecode(getAdhan);
    }
    mutedAdhan.add(adhanId);

    await flutterLocalNotificationsPlugin.cancel(adhanId);
    return await storage.writeData("adhan_muted", jsonEncode(mutedAdhan));
  }

  removeMutedAdhan(int adhanId) async {
    final storage = SecuredStorage();
    final getAdhan = await storage.readData(key: "adhan_muted");
    List mutedAdhan = [];
    if (getAdhan != null) {
      mutedAdhan = await jsonDecode(getAdhan);
    }
    if (mutedAdhan.contains(adhanId)) {
      mutedAdhan.remove(adhanId);
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await scheduleSingleNotification(
          flutterLocalNotificationsPlugin, adhanId);
    }

    return await storage.writeData("adhan_muted", jsonEncode(mutedAdhan));
  }

  getMutedList() async {
    final storage = SecuredStorage();
    final result = await storage.readData(key: "adhan_muted");
    return jsonDecode(result ?? '[]');
  }

  scheduleNotification() async {
    //scheduleAllTime
    final prayer = PrayerTimeUtil();
    

    final solatTime = await prayer.getSpecificTime(DateTime.now(), raw: true);
    final List getMutedAdhan = await getMutedList();
    tz.initializeTimeZones();
    // await flutterLocalNotificationsPlugin.cancelAll();

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     99,
    //     "${single.$1} | ${single.$3}",
    //     getRandomVerse(),
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    //     // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
    //     NotificationDetails(
    //         iOS: const DarwinNotificationDetails(
    //             sound: "shorten_adhan.caf",
    //             presentAlert: true,
    //             presentBadge: true,
    //             presentSound: true,
    //             subtitle: "Start: 4:00pm | End: 4:00am",
    //             presentBanner: true),
    //         android: AndroidNotificationDetails('solat_time_4', 'Solat Prayer',
    //             color: const Color(0xFFCD3DFF),
    //             onlyAlertOnce: true,
    //             fullScreenIntent: true,
    //             colorized: true,
    //             enableVibration: true,
    //             importance: Importance.high,
    //             subText: "${single.$3} - ${single.$4}",
    //             sound: const RawResourceAndroidNotificationSound('adhan'),
    //             channelDescription: 'This is for showing Solat time')),
    //     androidScheduleMode: AndroidScheduleMode.exact,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime);

    // return;
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
      for (int i = 0; i < solatTime.length; i++) {
        if (!getMutedAdhan.contains(i)) {
          // await flutterLocalNotificationsPlugin.cancel(i);
          await flutterLocalNotificationsPlugin.zonedSchedule(
              i,
              "${solatTime[i].$1} | ${solatTime[i].$3}",
              getRandomVerse(),
              tz.TZDateTime.parse(tz.local, solatTime[i].$2.toString()),
              // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
              NotificationDetails(
                  iOS: DarwinNotificationDetails(
                      sound: "shorten_adhan.caf",
                      presentAlert: true,
                      presentBadge: true,
                      presentSound: true,
                      subtitle: "${solatTime[i].$3} - ${solatTime[i].$4}",
                      presentBanner: true),
                  android: const AndroidNotificationDetails(
                      'solat_time_', 'Solat Prayer',
                      color: Color(0xFFCD3DFF),
                      onlyAlertOnce: true,
                      fullScreenIntent: true,
                      colorized: true,
                      enableVibration: true,
                      importance: Importance.defaultImportance,
                      sound: RawResourceAndroidNotificationSound('adhan'),
                      channelDescription: 'This is for showing Solat time')),
              androidScheduleMode: AndroidScheduleMode.exact,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              matchDateTimeComponents: DateTimeComponents.time);
        }
      }
    } catch (e) {
      return;
    }
  }

  scheduleSingleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      int adhanId) async {
    //scheduleAllTime
    final prayer = PrayerTimeUtil();
    final solatTime = await prayer.getSpecificTime(DateTime.now(), raw: true);
    final single = solatTime[adhanId];

    // return;
    tz.initializeTimeZones();
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          adhanId,
          single.$1,
          getRandomVerse(),
          tz.TZDateTime.parse(tz.local, single.$2.toString()),
          // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
          NotificationDetails(
              iOS: DarwinNotificationDetails(
                  sound: "shorten_adhan.caf",
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                  subtitle: "${single.$1} | ${single.$3} - ${single.$4}",
                  presentBanner: true),
              android: const AndroidNotificationDetails(
                  'solat_time', 'Solat Prayer',
                  channelDescription: 'This is for showing Solat time')),
          androidScheduleMode: AndroidScheduleMode.exact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);

      // await flutterLocalNotificationsPlugin.cancel(0);
    } catch (e) {
      return;
    }
  }
}

//   init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//       onDidReceiveLocalNotification: onDidReceivedNotification,
//     );

//     void onDidReceiveLocalNotification(
//     int id, String title?, String? body, String? payload) async {
//   // display a dialog with the notification details, tap ok to go to another page
//   showDialog(
//     context: context,
//     builder: (BuildContext context) => CupertinoAlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: [
//         CupertinoDialogAction(
//           isDefaultAction: true,
//           child: const Text('Ok'),
//           onPressed: () async {
//             Navigator.of(context, rootNavigator: true).pop();
//             await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => SecondScreen(payload),
//               ),
//             );
//           },
//         )
//       ],
//     ),
//   );
// }

// void onDidReceiveNotificationResponse(
//     NotificationResponse notificationResponse) async {
//   final String? payload = notificationResponse.payload;
//   if (notificationResponse.payload != null) {
//     debugPrint('notification payload: $payload');
//   }
//   await Navigator.push(
//     context,
//     MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
//   );
// }

// final InitializationSettings initializationSettings =
//     InitializationSettings(
//   android: initializationSettingsAndroid,
//   iOS: initializationSettingsDarwin,
// );

// await flutterLocalNotificationsPlugin.initialize(
//   initializationSettings,
//   onDidReceiveNotificationResponse =
//       (NotificationResponse notificationResponse) async {
//     // ...
//   },
//   onDidReceiveBackgroundNotificationResponse =
//       backgroundNotification(NotificationResponse),
// );


//android
  // const AndroidNotificationDetails androidNotificationDetails =
  //     AndroidNotificationDetails(
  //         'repeating channel id', 'repeating channel name',
  //         channelDescription: 'repeating description');
  // const NotificationDetails notificationDetails =
  //     NotificationDetails(android: androidNotificationDetails);

  // await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
  //     'repeating body', RepeatInterval.everyMinute, notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exact);

//   cancelNotification() async {
//     await flutterLocalNotificationsPlugin.cancel(0);
//   }

//   cancelAll() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }

