import 'package:babaloworo/shared/location_util.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PrayerTimeUtil {
  timezone() async {
    try {
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      // print(currentTimeZone);
      return currentTimeZone;
    } catch (e) {
      return 'Africa/Lagos';
    }
  }

  getSpecificTime(DateTime dateTime, {raw = false, nextPrayer = false}) async {
    final getCoordinates = LocationUtil();
    final storage = SecuredStorage();
        
    final Position position = await getCoordinates.initialize();
    // print(position);
    final String getTimezone = await timezone();

    PrayerTimes prayerTimes;
    try {
      prayerTimes = PrayerTimes(
        coordinates: Coordinates(position.latitude, position.longitude),
        calculationParameters: PrayerCalculationMethod.muslimWorldLeague(),
        locationName: getTimezone,
        dateTime: dateTime, // Specify the desired date
      );
    } catch (e) {
      prayerTimes = PrayerTimes(
        coordinates: Coordinates(position.latitude, position.longitude),
        calculationParameters: PrayerCalculationMethod.muslimWorldLeague(),
        locationName: getTimezone,
        dateTime: dateTime, // Specify the desired date
      );
    }

    if (nextPrayer == true) {
      List prayer = [
        [
          PrayerType.fajr,
          getCustomizedDate(prayerTimes.fajrStartTime!),
          prayerTimes.fajrStartTime!
        ],
        [
          PrayerType.dhuhr,
          getCustomizedDate(prayerTimes.dhuhrStartTime!),
          prayerTimes.dhuhrStartTime!
        ],
        [
          PrayerType.asr,
          getCustomizedDate(
              prayerTimes.asrStartTime!.subtract(const Duration(hours: 1))),
          prayerTimes.asrStartTime!.subtract(const Duration(hours: 1))
        ],
        [
          PrayerType.maghrib,
          getCustomizedDate(prayerTimes.maghribStartTime!),
          prayerTimes.maghribStartTime!
        ],
        [
          PrayerType.isha,
          getCustomizedDate(prayerTimes.ishaStartTime!),
          prayerTimes.ishaStartTime!
        ]
      ];
    
      List prayerSolat = [];
      if (prayerTimes.nextPrayer() == PrayerType.sunrise) {
        prayerSolat = prayer[1];
      } else {
        for (var element in prayer) {
          if (prayerTimes.nextPrayer() == element[0]) {
            prayerSolat = element;
            break;
          }
        }
      }
      if (prayerSolat.isNotEmpty && prayerSolat[0] == PrayerType.asr) {
        
        final checkDifference =
            DateTime.now().difference(prayerTimes.asrStartTime!.subtract(const Duration(hours: 1)));
        if (checkDifference.inSeconds > 0) {
          final maghribNext = [
            PrayerType.maghrib,
            getCustomizedDate(prayerTimes.maghribStartTime!),
            prayerTimes.maghribStartTime!
          ];
          prayerSolat = maghribNext;
        }
      }

      if (prayerSolat.isEmpty) {
        final fajrNext = [
          PrayerType.fajr,
          getCustomizedDate(
              prayerTimes.fajrStartTime!.add(const Duration(days: 1))),
          prayerTimes.fajrStartTime!.add(const Duration(days: 1))
        ];
        prayerSolat = fajrNext;
      }

      List<String> arr = prayerSolat[0].split("");
      String first = arr[0].toUpperCase();
      arr.removeAt(0);

      return ["$first${arr.join("")} - ${prayerSolat[1]}", prayerSolat[2]];
    }

    SunnahInsights sunnahInsights = SunnahInsights(prayerTimes);
    if (raw == true) {
      return [
        (
          "Fajr Prayer Time",
          prayerTimes.fajrStartTime!,
          getCustomizedDate(prayerTimes.fajrStartTime!),
          getCustomizedDate(prayerTimes.fajrEndTime!)
        ),
        (
          'Dhuhr Prayer Time',
          prayerTimes.dhuhrStartTime!,
          getCustomizedDate(prayerTimes.dhuhrStartTime!),
          getCustomizedDate(prayerTimes.dhuhrEndTime!)
        ),
        (
          'Asr Prayer Time',
          prayerTimes.asrStartTime!.subtract(const Duration(hours: 1)),
          getCustomizedDate(
              prayerTimes.asrStartTime!.subtract(const Duration(hours: 1))),
          getCustomizedDate(prayerTimes.asrEndTime!)
        ),
        (
          'Maghrib Prayer Time',
          prayerTimes.maghribStartTime!,
          getCustomizedDate(prayerTimes.maghribStartTime!),
          getCustomizedDate(prayerTimes.maghribEndTime!)
        ),
        (
          'Ishai Prayer Time',
          prayerTimes.ishaStartTime!,
          getCustomizedDate(prayerTimes.ishaStartTime!),
          getCustomizedDate(prayerTimes.ishaEndTime!)
        ),
      ];
    }
    return [
      (
        'Fajr',
        getCustomizedDate(prayerTimes.fajrStartTime!),
        prayerTimes.nextPrayer() == PrayerType.fajr,
        0,
      ),
      (
        'Sunrise',
        getCustomizedDate(prayerTimes.sunrise!),
        prayerTimes.nextPrayer() == PrayerType.sunrise,
        -2,
      ),
      (
        'Dhuhr',
        getCustomizedDate(prayerTimes.dhuhrStartTime!),
        prayerTimes.nextPrayer() == PrayerType.dhuhr,
        1,
      ),
      (
        'Asr',
        getCustomizedDate(
            prayerTimes.asrStartTime!.subtract(const Duration(hours: 1))),
        prayerTimes.nextPrayer() == PrayerType.asr,
        2,
      ),
      (
        'Maghrib',
        getCustomizedDate(prayerTimes.maghribStartTime!),
        prayerTimes.nextPrayer() == PrayerType.maghrib,
        3,
      ),
      (
        'Ishai',
        getCustomizedDate(prayerTimes.ishaStartTime!),
        prayerTimes.nextPrayer() == PrayerType.isha,
        4
      ),
      (
        'Middle of Night',
        getCustomizedDate(sunnahInsights.middleOfTheNight),
        false,
        -1,
      )
    ];
  }

  getCustomizedDate(DateTime date) => DateFormat.jm().format(date);

  getTodayTime() async {
    final todayPrayer = await getSpecificTime(DateTime.now());
    return todayPrayer;
  }
}
