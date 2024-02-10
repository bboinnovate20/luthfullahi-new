import 'dart:async';
import 'dart:io';
import 'package:babaloworo/calendar/calendart_util.dart';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/prayer_time/notification_util.dart';
import 'package:babaloworo/prayer_time/prayer_time_util.dart';
import 'package:babaloworo/shared/ads.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/notification_setup.dart';
import 'package:babaloworo/shared/permission_dialogue.dart';
import 'package:babaloworo/shared/primary_btn.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
 ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final ScrollController _controller = ScrollController();
  bool isScrolled = false;
  bool permission = false;

  void _scrollListener() {
    if (_controller.offset > 0.0) {
      setState(() {
        isScrolled = true;
      });
    } else {
      setState(() {
        isScrolled = false;
      });
    }
  }
  bool isFirst = true;


  setupNotificationPermission(NotificationUtil notification, SecuredStorage storage, firstTime ) async {
    bool result = false;
    result = await notification.requestPermission();
    if (result) {
        if(firstTime == null) await storage.writeData("first_time", "true");
            // ignore: use_build_context_synchronously
        await setupNotification(context);
    }
    
    final locationStatus = await getLocationPermission();
    if(locationStatus) {
        setState(() => permission = true);
      }
      await notification.scheduleNotification();
 
  }

  getLocationPermission() async {
    final storage = SecuredStorage();
    final readStatus = await storage.readData(key: "location");

    if (readStatus == null || readStatus == "false") {
      await storage.writeData("location", "true");
      // ignore: use_build_context_synchronously
      final askPermission = await showPermissionDialog(context, "This app needs your location to get the best experience for Qibla and Adhan prayer times accuracy. Do you want to turn on your location?", Icons.location_on);
      await storage.writeData("location", askPermission.toString());
      return askPermission;
    }
    return true;
  }

  init() async {
    final notification = NotificationUtil();
    final storage = SecuredStorage();
    final firstTime = await storage.readData(key: "first_time");
    
    setupNotificationPermission(notification, storage, firstTime);
    
  }

  setupListener() {
    _controller.addListener(_scrollListener);
  }

  @override
  void initState() {
    super.initState();
    setupListener();
    init();
  }
    List anonymousContent () => [
      const MainFeatures(),
      const PremiumSignIn(),
      const DonationBanner(),
    ];

    List featuresContent () => [     
      const MainFeatures(),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ButtonExtended(
            title: "Luthfullahi Adhkar",
            action: () => {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: NavigatorNamed.luthfullahi, withNavBar: false)
                },
            icon: "assets/icons/tesbih.png"),
      ),
      const OtherFeatures(),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: ButtonExtended(
            title: "Chat with Sheikh",
            action: () => {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: NavigatorNamed.chat, withNavBar: false)
                },
            icon: "assets/icons/chat.png"),
      ),
      const DonationBanner(),
    ]
        .animate(interval: 100.ms)
        .fadeIn(duration: 400.ms)
        .slide(duration: 100.ms, curve: Curves.easeIn);



  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(userStateAuth);

    return  Scaffold(
      extendBody: true,
      body: SafeArea(
         bottom: false,
        child: Column(
        children: [
                      TopHeaderDashboard(
                isScrolledHeadStyle: isScrolled,
                name: ref
                        .watch(userAuthentication)
                        .getCurrentUser()
                        ?.displayName ??
                    "User"),
                      Container(margin: const EdgeInsets.only(right: 12, left: 12),child: permission == true ? 
                        ThumbnailDashboard(isPermitted: permission):const ThumbnailDashboard(key: GlobalObjectKey(1),  isPermitted: false)),    
                      Expanded(
                        child: Stack(
                          children: [
                            const Positioned(
                      bottom: 100, left: 0, right: 0, child: Ads()),
                            Container(
                              padding: const EdgeInsets.only(bottom: 180),
                              margin: const EdgeInsets.only(right: 12, left: 12),
                              child: authState.when(data: (data) {
                                    if (data != null) {
                                      return ListView.builder(
                                        controller: _controller,
                                        itemCount: featuresContent().length,
                                        itemBuilder: (context, index) {
                                          
                                          return featuresContent()[index];
                                        },
                                      );
                                    }
                              
                                    return ListView.builder(
                                      controller: _controller,
                                      itemCount: anonymousContent().length,
                                      itemBuilder: (context, index) {
                                        
                                        return anonymousContent()[index];
                                      },
                                    );
                                  },
                                  error: (error, trace) => Text("$error error"),
                                  loading: () => const Text("loading")),
                            ),
                          ],
                        ),
                      )
                      
        ],
      ))
    //                   ),
    );
    

    // return Scaffold(
    //     extendBody: true,
    //     body: SafeArea(
    //       bottom: false,
    //       child: Column(children: [
    //         TopHeaderDashboard(
    //             isScrolledHeadStyle: isScrolled,
    //             name: ref
    //                     .watch(userAuthentication)
    //                     .getCurrentUser()
    //                     ?.displayName ??
    //                 "User"),
    //         Expanded(
    //           child: Stack(
    //             children: [
    //               const Positioned(
    //                   bottom: 100, left: 0, right: 0, child: Ads()),
    //               Container(
    //                   padding: const EdgeInsets.only(bottom: 180),
    //                   margin: const EdgeInsets.only(right: 12, left: 12),
    //                   child: ref.watch(userAuthentication).notificationPermission == true ? const Text("heelloo")
    //                    :  const Text("new")
                       
    //                   //  authState.when(data: (data) {
    //                   //       if (data != null) {
    //                   //         return ListView.builder(
    //                   //           controller: _controller,
    //                   //           itemCount: featuresContent.length,
    //                   //           itemBuilder: (context, index) {
    //                   //             if(index == 0) return ThumbnailDashboard(isPermitted: notificationPermission);
    //                   //             return featuresContent[index];
    //                   //           },
    //                   //         );
    //                   //       }

    //                   //       return ListView.builder(
    //                   //         controller: _controller,
    //                   //         itemCount: anonymousContent.length,
    //                   //         itemBuilder: (context, index) {
    //                   //           if(index == 0) return ThumbnailDashboard(isPermitted: notificationPermission);
    //                   //           return anonymousContent[index];
    //                   //         },
    //                   //       );
    //                   //     },
    //                   //     error: (error, trace) => Text("$error error"),
    //                   //     loading: () => const Text("loading"))
                      
    //                   )
    //             ],
    //           ),
    //         ),
    //       ]),
    //     ));
  
  
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_scrollListener);
  }
}

class TopHeaderDashboard extends StatefulWidget {
  final bool isScrolledHeadStyle;
  final String name;
  const TopHeaderDashboard(
      {super.key, required this.isScrolledHeadStyle, this.name = "User"});

  @override
  State<TopHeaderDashboard> createState() => _TopHeaderDashboardState();
}

class _TopHeaderDashboardState extends State<TopHeaderDashboard> {
  List myDate = ["", ""];

  getDate() {
    final date = CalendarUtil();
    final result = date.init();
    final arr = [result['fullDate'], result['date']];
    setState(() {
      myDate = arr;
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: widget.isScrolledHeadStyle
          ? Theme.of(context).colorScheme.primary
          : Colors.transparent,
      margin: const EdgeInsets.only(bottom: 3),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Salaam Alaykum "),
                Text(
                  widget.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(myDate[0],
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(myDate[1])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ThumbnailDashboard extends StatefulWidget {
  final bool isPermitted;
  const ThumbnailDashboard({super.key, required this.isPermitted});

  @override
  State<ThumbnailDashboard> createState() => _ThumbnailDashboardState();
}

class _ThumbnailDashboardState extends State<ThumbnailDashboard> {
  List nextPrayer = ["", ""];

  String differences = "";
  
  getCurrentDate() async {
    if(widget.isPermitted) {
      continuousDate();
    }      
  }
    
  

  continuousDate() async {
    final prayerTime = PrayerTimeUtil();
          final List result =
              await prayerTime.getSpecificTime(DateTime.now(), nextPrayer: true);

          setState(() {
            nextPrayer = result;
          });

          startCountDown(result[1]);
  }

  startCountDown(DateTime date) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final diff = DateTime.now().difference(date);
      if (diff.inSeconds == 0) {
        timer.cancel();
        continuousDate();
      } else {
        setState(() {
          differences = diff.toString().split(".")[0];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentDate();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          image: const DecorationImage(
              scale: 3,
              alignment: Alignment.bottomRight,
              image:
                  AssetImage('assets/images/thumbnail_background_prayer.png'),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF62007B), Color(0xFFC235ED)])),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: [
                  Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text("Next Prayer",
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(nextPrayer[0],
                          textDirection: TextDirection.ltr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white)),
                      NextPrayerTimeCountDown(time: differences),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: GestureDetector(
                          onTap: () => {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: NavigatorNamed.prayerTime,
                                withNavBar: false)
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              textDirection: TextDirection.ltr,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "View Today Prayer Time",
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Image.asset(
                                    "assets/icons/right_arrow.png",
                                    width: 6,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
            GestureDetector(
              onTap: () => {
                PersistentNavBarNavigator.pushNewScreen(context,
                    screen: NavigatorNamed.notification, withNavBar: false)
              },
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/icons/notification.png",
                      width: 17, height: 19),
                ),
                Positioned(
                  right: 8,
                  top: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class NextPrayerTimeCountDown extends StatelessWidget {
  final String time;
  const NextPrayerTimeCountDown({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(time,
          textDirection: TextDirection.ltr,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white, fontSize: 18)),
    );
  }
}

class MainFeatures extends StatelessWidget {
  const MainFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FeatureIcon(
            color: const Color(0xFFFFF500),
            icon: "quran_illustrator",
            caption: "Al-Quran",
            action: () => {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: NavigatorNamed.quran(isWithBackButton: true),
                  withNavBar: false)
            },
          ),
          FeatureIcon(
              color: const Color(0xFFC8EDA7),
              icon: "hadith_illustrator",
              caption: "Hadith",
              action: () => {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen:
                            NavigatorNamed.mainHadith(isWithBackButton: true),
                        withNavBar: false)
                  }),
          FeatureIcon(
              color: const Color(0xFFFBC79E),
              icon: "moon_illustrator",
              caption: "Fiqh",
              action: () => {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: NavigatorNamed.fiqh, withNavBar: false)
                  }),
          FeatureIcon(
            color: const Color(0xFFC8EDA7),
            icon: "hand_dua_illustrator",
            caption: "Dua",
            action: () => {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: NavigatorNamed.dua, withNavBar: false)
            },
          ),
        ],
      ),
    );
  }
}

class FeatureIcon extends StatelessWidget {
  final Color color;
  final String icon;
  final String caption;
  final Function action;

  const FeatureIcon(
      {super.key,
      this.color = const Color(0xFFF7E3F2),
      required this.icon,
      required this.caption,
      required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset("assets/icons/$icon.png",
                  width: 60.8, height: 40.82),
            ),
          ),
          Text(caption)
        ],
      ),
    );
  }
}

class OtherFeatures extends StatelessWidget {
  const OtherFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FeatureIcon(
            color: Theme.of(context).colorScheme.tertiary,
            icon: "calendar",
            caption: "Calendar",
            action: () => {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: NavigatorNamed.calendar, withNavBar: false)
            },
          ),
          FeatureIcon(
              color: Theme.of(context).colorScheme.tertiary,
              icon: "tesbih_2",
              caption: "E-Tesbih",
              action: () => {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: NavigatorNamed.tesbih, withNavBar: false)
                  }),
          FeatureIcon(
              color: Theme.of(context).colorScheme.tertiary,
              icon: "qibla",
              caption: "Qibla",
              action: () => {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: NavigatorNamed.qibla, withNavBar: false)
                  }),
          FeatureIcon(
            color: Theme.of(context).colorScheme.tertiary,
            icon: "media",
            caption: "Media",
            action: () => {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: NavigatorNamed.media, withNavBar: false)
            },
          ),
        ],
      ),
    );
  }
}

class DonationBanner extends StatelessWidget {
  const DonationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFFFFBF0B), Color(0xFFFFF500)]),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Ongoing Project Donation",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Project Donation 2024",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Text("Luthfullahi Society of Nigeria")
                ],
              ),
              Image.asset("assets/images/donation_illustrator.png",
                  width: 80, height: 80)
            ],
          ),
        ));
  }
}

class PremiumSignIn extends ConsumerWidget {
  const PremiumSignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        if(Platform.isAndroid){
          await ref.read(userAuthentication).googleSignIn();
        }
        else {
          await ref.read(userAuthentication).appleSignIn();
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xFFFFBF0B), Color(0xFFFFF500)]),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 130,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Sign in for Premium Features",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Image.asset("assets/images/flower.png", width: 70, height: 60)
              ],
            ),
          )),
    );
  }
}
