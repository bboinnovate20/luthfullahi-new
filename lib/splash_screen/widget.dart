import 'dart:async';

import 'package:babaloworo/auth/auth.dart';
import 'package:babaloworo/firebase_options.dart';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/notification_database.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int top = 10;
  int top_2 = 10;
  double opacity = 0;
  double opacity_2 = 0;
  int duration = 500;

  initiateMessage() async {
    await initiateMessaging();
    unawaited(MobileAds.instance.initialize());
  }

  isFirstTime() async {
    try {
      final storage = SecuredStorage();
      final firstTime = await storage.readData(key: "first_time");
      if (firstTime != null) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavigation()),
          );
          setState(() {
            opacity = 0;
            opacity_2 = 0;
          });
        });
        return false;
      }
      await storage.writeData("first_time", "true");
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const FirstTimeAuth(
                  skipAllowed: true, isWithBackButton: false)),
        );
        setState(() {
          opacity = 0;
          opacity_2 = 0;
        });
      });
      return true;
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
        );
        setState(() {
          opacity = 0;
          opacity_2 = 0;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        top = 0;
        opacity = 1;
      });
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        top_2 = 0;
        opacity_2 = 1;
      });
    });
    isFirstTime();
    //moving to next
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SizedBox(
            // height: 40,
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: duration),
                  top: (MediaQuery.of(context).size.height / 3) - top,
                  left: (MediaQuery.of(context).size.width / 2) - (168 / 2),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: duration),
                    opacity: opacity,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: duration),
                      opacity: opacity,
                      child: Image.asset("assets/images/logo_round.png",
                          width: 168.93, height: 170.54),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  // bottom: 0,
                  duration: Duration(milliseconds: duration),
                  top: ((MediaQuery.of(context).size.height / 3) + 168.93) -
                      top_2,
                  left: ((MediaQuery.of(context).size.width / 2) - (168 / 2)),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: duration),
                    opacity: opacity_2,
                    child: Image.asset(
                      "assets/images/text_logo.png",
                      width: 170.93,
                      height: 80,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
