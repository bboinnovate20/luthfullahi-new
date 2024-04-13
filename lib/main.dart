import 'dart:async';
import 'dart:math';

import 'package:babaloworo/auth/auth_util.dart';
import 'package:babaloworo/dashboard/dashboard.dart';
import 'package:babaloworo/luthfullahi/luthfullahi_widget.dart';
import 'package:babaloworo/profile/profile.dart';
import 'package:babaloworo/quran/quran_widget.dart';
import 'package:babaloworo/shared/loading_state.dart';
import 'package:babaloworo/shared/notification_database.dart';
import 'package:babaloworo/shared/quran_notifier.dart';
import 'package:babaloworo/shared/theme.dart';
import 'package:babaloworo/splash_screen/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// firebase config
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//

final quranNotifierProvider =
    ChangeNotifierProvider<QuranNotifier>((ref) => QuranNotifier());
final userAuthentication = Provider((ref) => AuthProvider());
final userStateAuth =
    StreamProvider((ref) => ref.read(userAuthentication).authStateChange);
final loadingProvider = Provider<LoadingNotifier>((ref) => LoadingNotifier());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

try {
  await Firebase.initializeApp(
    name: "luthfullahi",
    options: DefaultFirebaseOptions.currentPlatform,
  );
} on Exception catch (e) {
  // TODO
}


  runApp(const ProviderScope(child: MyApp()));
}

class Error extends StatelessWidget {
  const Error({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Babaloworo App',
        theme: theme,
        home: const Scaffold(body: Center(child: Text("Hello this is the error $e"))));
        
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Babaloworo App',
        theme: theme,
        home: const SplashScreen());
        
  }
}
// home: const SplashScreen());
class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, state = 0});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      resizeToAvoidBottomInset: true,
      bottomScreenMargin: 0,
      confineInSafeArea: false,
      navBarHeight: 80,
      padding: const NavBarPadding.symmetric(vertical: 15, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration:
          NavBarDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 4,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ]),
      navBarStyle: NavBarStyle.style10,
      screens: _buildScreens(),
      items: _navBarsItems(context),
    );
  }
}

List<Widget> _buildScreens() {
  return [
    const Dashboard(),
    const Quran(),
    const LuthfullahiResource(),
    const Profile()
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems(context) {
  return [
    PersistentBottomNavBarItem(
        icon: Image.asset(
          "assets/icons/home_mosque.png",
          width: 24,
        ),
        title: ("Home"),
        activeColorSecondary: Colors.black,
        activeColorPrimary: Theme.of(context).colorScheme.primary),
    PersistentBottomNavBarItem(
      //
      icon: Image.asset(
        "assets/icons/open_quran.png",
        width: 24,
      ),
      activeColorSecondary: Colors.black,
      title: ("Quran"),
      activeColorPrimary: Theme.of(context).colorScheme.primary,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(
        "assets/icons/closed_quran_icon.png",
        width: 24,
      ),
      activeColorSecondary: Colors.black,
      title: ("Luthfullahi"),
      activeColorPrimary: Theme.of(context).colorScheme.primary,
    ),
    PersistentBottomNavBarItem(
      icon: Image.asset(
        "assets/icons/user.png",
        width: 24,
      ),
      activeColorSecondary: Colors.black,
      title: ("Profile"),
      activeColorPrimary: Theme.of(context).colorScheme.primary,
    ),
  ];
}
