import 'package:babaloworo/calendar/calendart_util.dart';
import 'package:babaloworo/prayer_time/notification_util.dart';
import 'package:babaloworo/prayer_time/prayer_time_util.dart';
import 'package:babaloworo/qibla/qibla_util.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PrayerTime extends StatefulWidget {
  const PrayerTime({super.key});

  @override
  State<PrayerTime> createState() => _PrayerTimeState();
}

class _PrayerTimeState extends State<PrayerTime> {
  List prayerTimes = [];
  String currentDate = "";
  List mutedList = [];

  init() async {
    final prayerTime = PrayerTimeUtil();
    final resultedTime = await prayerTime.getTodayTime();
    final notification = NotificationUtil();
    final getMutedList = await notification.getMutedList();
    // print(getMutedLIst);
    setState(() {
      mutedList = getMutedList;
      prayerTimes = resultedTime;
    });
  }

  getDate() {
    final date = CalendarUtil();
    final result = date.init();
    final stringFormat = "${result['fullDate']}  |  ${result['date']}";
    setState(() {
      currentDate = stringFormat;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainerWithGradientImage(
      title: "Prayer Time",
      bgColor: const Color(0xFFFBF8AB),
      isWithBackButton: true,
      boxDecoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFBF8AB), Color(0xFF777314)])),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Icon(Icons.arrow_back_ios_new_rounded,
                  //     color: Colors.white),
                  Text(
                    "Today's Prayer Time",
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(color: Colors.white),
                  ),
                  // const Icon(Icons.arrow_forward_ios_rounded,
                  //     color: Colors.white)
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              currentDate,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: prayerTimes.isNotEmpty
                ? Column(
                    children: prayerTimes
                        .map((solatTime) {
                          return EachSolat(
                              showSwitch: solatTime.$4 >= 0,
                              solatId: solatTime.$4,
                              solatName: solatTime.$1,
                              solatTime: solatTime.$2,
                              isCurrentSolat: solatTime.$3,
                              notificationStatus:
                                  !mutedList.contains(solatTime.$4));
                        })
                        .toList()
                        .animate(interval: 100.ms)
                        .fadeIn(duration: 400.ms)
                        .slide(duration: 100.ms, curve: Curves.easeIn))
                : const Text("No Prayer Times"),
          )
        ],
      ),
    );
  }
}

class EachSolat extends StatefulWidget {
  final String solatName;
  final String solatTime;
  final bool notificationStatus;
  final bool isCurrentSolat;
  final int solatId;
  final bool showSwitch;
  const EachSolat(
      {super.key,
      this.isCurrentSolat = false,
      this.showSwitch = true,
      required this.solatName,
      required this.solatId,
      required this.solatTime,
      required this.notificationStatus});

  @override
  State<EachSolat> createState() => _EachSolatState();
}

class _EachSolatState extends State<EachSolat> {
  late bool innerNotficationStatus;
  @override
  void initState() {
    super.initState();
    innerNotficationStatus = widget.notificationStatus;
  }

  changeAlertSetting(int id, bool status) async {
    if (id >= 0) {
      final notification = NotificationUtil();
      if (status) {
        await notification.removeMutedAdhan(id);
      } else {
        await notification.savedMutedAdhan(id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.isCurrentSolat
              ? Theme.of(context).colorScheme.primary
              : Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.5,
              child: Text(
                widget.solatName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.2,
              child: Text(
                  textAlign: TextAlign.center,
                  widget.solatTime,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2,
              child: widget.showSwitch
                  ? Switch.adaptive(
                      value: innerNotficationStatus,
                      onChanged: (value) async {
                        setState(() {
                          innerNotficationStatus = !innerNotficationStatus;
                        });
                        await changeAlertSetting(widget.solatId, value);
                      },
                      activeColor: Theme.of(context).colorScheme.secondary,
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
