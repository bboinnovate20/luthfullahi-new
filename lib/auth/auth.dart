import 'dart:io';

import 'package:babaloworo/main.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/primary_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class FirstTimeAuth extends ConsumerStatefulWidget {
  final bool skipAllowed;
  final bool isWithBackButton;
  const FirstTimeAuth(
      {super.key, this.skipAllowed = false, this.isWithBackButton = true});

  @override
  ConsumerState<FirstTimeAuth> createState() => _FirstTimeAuthState();
}

class _FirstTimeAuthState extends ConsumerState<FirstTimeAuth> {
  bool state = false;
  bool state_apple = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(userStateAuth);
    return authState.when(
        loading: () => const Scaffold(body: Center(child: Text("Loading"))),
        error: (_, error) => const Scaffold(body: Center(child: Text("Error"))),
        data: (data) {
          if (data != null) {
            if (widget.isWithBackButton) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BottomNavigation()),
                );
              });
            }
          }
          return Scaffold(
            
            appBar: AppBar(
              // toolbarHeight: 2,
              backgroundColor: Theme.of(context).colorScheme.background,
              leading: widget.isWithBackButton
                  ? Platform.isAndroid
                      ? GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                              size: 26,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        )
                  : Container(),
            ),
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/closed_quran.png",
                      width: 147.4, height: 151.1),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Image.asset("assets/images/salam_script.png",
                        width: 225.49, height: 55),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Welcome Pious Muslim",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Text(
                    "Explore lots of Quality Islamic content",
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "QURAN, HADITH, LUTHFULLAHI ADHKAR",
                    textAlign: TextAlign.center,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text("New or already or member"),
                  ),
                  
                  PrimaryButton(
                      isLoading: state,
                      action: () async {
                          if(state_apple == true) return;
                          try {
                            setState(() => state = true);
                            await ref.read(userAuthentication).googleSignIn();
                            setState(() => state = false);
                          } catch (e) {
                            setState(() => state = false);  
                          }
                          
                        },
                      icon: "assets/icons/google.png",
                      title: "Register/Login with Google"),
                    const Text("OR"),
                    
                   PrimaryButton(
                      isLoading: state == true ? false :state_apple,
                      action: () async {
                          if(state == true) return;
                          try {
                          setState(() => state_apple = true);
                          await ref.read(userAuthentication).appleSignIn();
                          } catch (e) {
                          setState(() => state_apple = false);}
                        },
                      iconData: Icons.apple,
                      title: "Register/Login with Apple"),
                  if (widget.skipAllowed)
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavigation()),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          "Skip this for now",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        });
  }
}
