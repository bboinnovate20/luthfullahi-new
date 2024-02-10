import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class CalendarUtil {
  HijriCalendar date = HijriCalendar();
  HijriCalendar customDate = HijriCalendar();

  CalendarUtil() {
    date = HijriCalendar.now();
    customDate = HijriCalendar();
  }

  init() {
    this.date = HijriCalendar.now();
    customDate = HijriCalendar.addMonth(this.date.hYear, this.date.hMonth);
    final startFrom = customDate.fullDate().split(",")[0];
    final daysInMonth =
        this.date.getDaysInMonth(this.date.hYear, this.date.hMonth);
    final currentDay = this.date.hDay;
    final date = this
        .date
        .hijriToGregorian(this.date.hYear, this.date.hMonth, this.date.hDay);

    Map dateFormat = {
      'startFrom': startFrom,
      'daysInMonth': daysInMonth,
      'currentDay': currentDay,
      'fullDate': this.date.fullDate(),
      'date': DateFormat('dd MMM, y').format(date).toString()
    };

    return dateFormat;
  }

  changeDate(int day) {
    final newDate =
        customDate.hijriToGregorian(customDate.hYear, customDate.hMonth, day);
    customDate.hDay = day;
    return [
      customDate.fullDate(),
      DateFormat('dd MMM, y').format(newDate).toString()
    ];
  }

  increaseDate() {
    final newMonth = customDate.hMonth + 1;
    customDate =
        HijriCalendar.addMonth(customDate.hYear, customDate.hMonth + 1);
    bool isCurrentDate =
        date.hYear == customDate.hYear && date.hMonth == customDate.hMonth;

    if (customDate.isValid() && newMonth <= 12) {
      if (newMonth == 12) {
        customDate.hYear += 1;
      }
      final startFrom = customDate.fullDate().split(",")[0];
      final daysInMonth =
          customDate.getDaysInMonth(customDate.hYear, customDate.hMonth);
      final fullDate = customDate.fullDate();
      final engDate =
          customDate.hijriToGregorian(customDate.hYear, customDate.hMonth, 1);
      return {
        'startFrom': startFrom,
        'daysInMonth': daysInMonth,
        'currentDay': isCurrentDate == true ? date.hDay : -1,
        'fullDate': fullDate,
        'engDate': DateFormat('dd MMM, y').format(engDate).toString()
      };
    }

    customDate = HijriCalendar.addMonth(customDate.hYear + 1, 1);
    if (customDate.isValid()) {
      final startFrom = customDate.fullDate().split(",")[0];
      final daysInMonth = customDate.getDaysInMonth(customDate.hYear, 1);
      final fullDate = customDate.fullDate();
      final engDate = date.hijriToGregorian(customDate.hYear, 1, 1);
      return {
        'startFrom': startFrom,
        'daysInMonth': daysInMonth,
        'fullDate': fullDate,
        'engDate': DateFormat('dd MMM, y').format(engDate).toString()
      };
    }
    return throw ErrorDescription("Date Exceeded");
  }

  decreaseDate() {
    final newMonth = customDate.hMonth - 1;
    customDate =
        HijriCalendar.addMonth(customDate.hYear, customDate.hMonth - 1);
    bool isCurrentDate =
        date.hYear == customDate.hYear && date.hMonth == customDate.hMonth;

    if (customDate.isValid()) {
      if (newMonth == 12) {
        customDate.hYear += 1;
      }
      final startFrom = customDate.fullDate().split(",")[0];
      final daysInMonth =
          customDate.getDaysInMonth(customDate.hYear, customDate.hMonth);
      final fullDate = customDate.fullDate();
      final engDate =
          customDate.hijriToGregorian(customDate.hYear, customDate.hMonth, 1);
      return {
        'startFrom': startFrom,
        'daysInMonth': daysInMonth,
        'currentDay': isCurrentDate == true ? date.hDay : -1,
        'fullDate': fullDate,
        'engDate': DateFormat('dd MMM, y').format(engDate).toString()
      };
    }

    return throw ErrorDescription("Date Exceeded");
  }
}
