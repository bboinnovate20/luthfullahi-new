import 'package:babaloworo/calendar/calendart_util.dart';
import 'package:babaloworo/local_resource/islamic_calendar/islamic_calendar.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';

class IslamicCalendar extends StatefulWidget {
  const IslamicCalendar({super.key});

  @override
  State<IslamicCalendar> createState() => _IslamicCalendarState();
}

class _IslamicCalendarState extends State<IslamicCalendar> {
  List holidayList = [];
  String engDate = "";
  String fullDate = "";

  String day = 'Sunday';

  int daysInMonth = 30;

  int currentDay = 1;
  int currentDayState = 1;
  CalendarUtil date = CalendarUtil();

  changeDayState(int day) {
    if (day <= daysInMonth) {
      final changeDay = date.changeDate(day);
      setState(() {
        currentDayState = day;
        fullDate = changeDay[0];
        engDate = changeDay[1];
      });
    }
  }

  decreaseMonth() {
    try {
      final newDate = date.decreaseDate();
      setState(() {
        currentDayState = 1;
        currentDay = newDate['currentDay'];
        day = newDate['startFrom'];
        daysInMonth = newDate['daysInMonth'];

        fullDate = newDate['fullDate'];
        engDate = newDate['engDate'];
      });
    } catch (e) {
      return;
    }
  }

  increaseDate() {
    try {
      final newDate = date.increaseDate();
      setState(() {
        currentDayState = 1;
        currentDay = newDate['currentDay'];
        day = newDate['startFrom'];
        daysInMonth = newDate['daysInMonth'];

        fullDate = newDate['fullDate'];
        engDate = newDate['engDate'];
      });
    } catch (e) {
      return;
    }
  }

  init() {
    setState(() {
      date = CalendarUtil();
      Map dateN = date.init();
      currentDayState = dateN['currentDay'];
      currentDay = dateN['currentDay'];
      day = dateN['startFrom'];
      daysInMonth = dateN['daysInMonth'];

      fullDate = dateN['fullDate'];
      engDate = dateN['date'];
    });

    // final date = CalendarUtil();
    // Map dateN = date.init();
  }

  loadHolidays() async {
    final holiday = IslamicCalendarUtil();
    final result = await holiday.getListOfHoliday();
    setState(() {
      holidayList = result;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    loadHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        title: "Islamic Calendar",
        isWithBackButton: true,
        color: Colors.white,
        bgColor: Colors.white,
        body: Column(
          children: [
            Text(
              fullDate,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(engDate),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: GestureDetector(
                      onTap: () => decreaseMonth(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Expanded(
                      child: CalendarDates(
                          day: day,
                          daysInMonth: daysInMonth,
                          currentDay: currentDay,
                          currentDayState: currentDayState,
                          getCurrentDay: (day) => {changeDayState(day)}
                          // setState(() => monthDay = int.parse(day)),
                          )),
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: () => increaseDate(),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.black12,
              thickness: 1,
              height: 50,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Text(
                        "Islamic Holidays",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )),
                  holidayList.isEmpty
                      ? Container()
                      : Expanded(
                          child: ListView.builder(
                              itemCount: holidayList.length,
                              itemBuilder: (context, index) {
                                return ListCard(
                                  isAction: false,
                                  title: holidayList[index]['Holiday'],
                                  subtitle: holidayList[index]['Hijri'],
                                  action: () => {},
                                  isGradient: true,
                                );
                              }),
                        )
                ],
              ),
            )
          ],
        ));
  }
}

class CalendarDates extends StatefulWidget {
  // final Function getCurrentDay;
// const CalendarDates({super.key, required this.getCurrentDay});

  final String day;
  final int daysInMonth;
  final int currentDay;
  final int currentDayState;
  final Function getCurrentDay;
  const CalendarDates(
      {super.key,
      required this.day,
      required this.daysInMonth,
      required this.currentDay,
      required this.currentDayState,
      required this.getCurrentDay});

  @override
  State<CalendarDates> createState() => _CalendarDatesState();
}

class _CalendarDatesState extends State<CalendarDates> {
  final int maxDayPerLine = 7;

  final Map<String, int> startDays = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  @override
  void initState() {
    super.initState();
    // init();
  }

  generateRows(Map<String, int> startDays, int daysInMonth, int maxDayPerLine) {
    List<Row> listOfRows = [];
    int endValue = (7 - startDays[widget.day]!) + 1;

    // heading
    listOfRows.add(eachLine(1, endValue, isHeading: true));

    // remaining line
    listOfRows.add(eachLine(1, endValue));

    int i = endValue + 1;
    int lastRemainValue = 0;
    while (i <= daysInMonth) {
      int nextValue = i + maxDayPerLine - 1;
      if (nextValue <= daysInMonth) {
        listOfRows.add(eachLine(i, i = nextValue));
        i++;
      } else {
        lastRemainValue = i;
        break;
      }
    }

    // last line
    listOfRows.add(eachLine(lastRemainValue, daysInMonth, trailing: true));
    return listOfRows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: generateRows(startDays, widget.daysInMonth, maxDayPerLine),
    );
  }

  Row eachLine(int startValue, int endValue,
      {trailing = false, isHeading = false}) {
    int length = (endValue - startValue) + 1;
    List<String> generateArray = [];

    if (isHeading) {
      List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
      generateArray.addAll(days);
    }
    if (length <= 7 && !isHeading) {
      if (trailing) {
        for (int i = startValue; i <= endValue; i++) {
          // if (widget.currentDay == i) {
          //   // generateArray.add("$i,c");
          // } else {
            generateArray.add(i.toString());
          // }
        }
        generateArray.addAll(List.filled(7 - length, "0"));
      } else {
        int leadingNumber = maxDayPerLine - length;

        generateArray = List<String>.filled(leadingNumber, "0", growable: true);

        for (int i = startValue; i <= endValue; i++) {
          generateArray.add(i.toString());
        }
      }
    }

    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: generateArray
          .map((e) => e == "0"
              ? const SizedBox(width: 35, child: Text(""))
              : GestureDetector(
                  onTap: () {
                    widget.getCurrentDay(int.parse(e));
                    // changeDayState(int.parse(e));
                  },
                  child: SizedBox(
                    width: 35,
                    child: e == widget.currentDay.toString()
                        ? Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFCD3DFF),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(e,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white)))
                        : e == widget.currentDayState.toString()
                            ? Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF7E3F2),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  e,
                                  textAlign: TextAlign.center,
                                  style: isHeading
                                      ? const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFCD3DFF))
                                      : const TextStyle(),
                                ),
                              )
                            : Text(
                                e,
                                textAlign: TextAlign.center,
                                style: isHeading
                                    ? const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFCD3DFF))
                                    : const TextStyle(),
                              ),
                  ),
                ))
          .toList(),
    );
  }
}
