import 'dart:io';

import 'package:babaloworo/auth/auth.dart';
import 'package:babaloworo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScaffoldContainer extends ConsumerWidget {
  final Widget body;
  final bool isPremiumFeature;
  final String title;
  final String subtitle;
  final bool isCustomWidget;
  final Widget customWidget;
  final Color color;
  final bool isWithBackButton;
  final Widget rightWidget;
  final double height;
  final Widget bottomNav;
  final bool darkMode;
  final LinearGradient gradient;
  final bool isGradient;
  final Color bgColor;
  final Color titleColor;
  final Color leadingColor;
  final BoxDecoration? customDecoration;
  const ScaffoldContainer(
      {super.key,
      this.isPremiumFeature = true,
      this.bgColor = Colors.white,
      this.isGradient = false,
      this.bottomNav = const Text(""),
      this.gradient = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF62007B), Color(0xFFC235ED)]),
      this.rightWidget = const Text(""),
      this.isWithBackButton = false,
      this.customWidget = const Text(""),
      this.isCustomWidget = false,
      this.customDecoration,
      required this.title,
      required this.body,
      this.titleColor = Colors.black,
      this.darkMode = false,
      this.height = 85,
      this.subtitle = "",
      this.leadingColor = Colors.black,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userStateAuth);
    if (isPremiumFeature) {
      return authState.when(
          data: (data) {
            if (data != null) {
              return MainScreen(
                  bottomNav: bottomNav,
                  bgColor: bgColor,
                  height: height,
                  isWithBackButton: isWithBackButton,
                  leadingColor: leadingColor,
                  title: title,
                  titleColor: titleColor,
                  isCustomWidget: isCustomWidget,
                  customWidget: customWidget,
                  subtitle: subtitle,
                  rightWidget: rightWidget,
                  customDecoration: customDecoration,
                  isGradient: isGradient,
                  color: color,
                  gradient: gradient,
                  body: body);
            }

            return FirstTimeAuth(
                skipAllowed: false, isWithBackButton: isWithBackButton);
          },
          loading: () => const Text("Loading"),
          error: (_, __) => const Text("error"));
    }
    return MainScreen(
        bottomNav: bottomNav,
        bgColor: bgColor,
        height: height,
        isWithBackButton: isWithBackButton,
        leadingColor: leadingColor,
        title: title,
        titleColor: titleColor,
        isCustomWidget: isCustomWidget,
        customWidget: customWidget,
        subtitle: subtitle,
        rightWidget: rightWidget,
        customDecoration: customDecoration,
        isGradient: isGradient,
        color: color,
        gradient: gradient,
        body: body);
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.bottomNav,
    required this.bgColor,
    required this.height,
    required this.isWithBackButton,
    required this.leadingColor,
    required this.title,
    required this.titleColor,
    required this.isCustomWidget,
    required this.customWidget,
    required this.subtitle,
    required this.rightWidget,
    required this.customDecoration,
    required this.isGradient,
    required this.color,
    required this.gradient,
    required this.body,
  });

  final Widget bottomNav;
  final Color bgColor;
  final double height;
  final bool isWithBackButton;
  final Color leadingColor;
  final String title;
  final Color titleColor;
  final bool isCustomWidget;
  final Widget customWidget;
  final String subtitle;
  final Widget rightWidget;
  final BoxDecoration? customDecoration;
  final bool isGradient;
  final Color color;
  final LinearGradient gradient;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNav,
      extendBody: true,
      backgroundColor: bgColor,
      appBar: AppBar(
          toolbarHeight: height,
          leadingWidth: isWithBackButton ? 50 : 0,
          backgroundColor: bgColor,
          leading: isWithBackButton
              ? Platform.isAndroid
                  ? GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: leadingColor,
                          size: 26,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: leadingColor,
                        size: 20,
                      ),
                    )
              : Container(),
          title: Container(
            padding: isWithBackButton
                ? const EdgeInsets.all(0)
                : const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: isWithBackButton ? 20 : 22,
                            color: titleColor),
                      ),
                      isCustomWidget
                          ? customWidget
                          : subtitle.isNotEmpty
                              ? Text(
                                  subtitle,
                                  // maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.black54),
                                )
                              : Container(),
                    ],
                  ),
                ),
                rightWidget,
              ],
            ),
          ),
          centerTitle: false),
      body: Container(
        height: double.infinity,
        decoration: customDecoration ??
            (isGradient
                ? BoxDecoration(color: color, gradient: gradient)
                : BoxDecoration(color: color)),
        child: Padding(
          padding: const EdgeInsets.only(right: 12, left: 12),
          child: body,
        ),
      ),
    );
  }
}

class ScaffoldContainerWithGradientImage extends ConsumerWidget {
  final Widget body;
  final String title;
  final String subtitle;
  final bool isCustomWidget;
  final Widget customWidget;
  final Color color;
  final bool isPremiumFeature;
  final bool isWithBackButton;
  final Widget rightWidget;
  final double height;
  final Widget bottomNav;
  final bool darkMode;
  final Color leadingColor;
  final BoxDecoration boxDecoration;
  final Color bgColor;
  final Color textColor;
  const ScaffoldContainerWithGradientImage(
      {super.key,
      this.isPremiumFeature = true,
      this.bgColor = Colors.white,
      this.textColor = Colors.black,
      required this.boxDecoration,
      this.bottomNav = const Text(""),
      this.rightWidget = const Text(""),
      this.isWithBackButton = false,
      this.customWidget = const Text(""),
      this.isCustomWidget = false,
      required this.title,
      required this.body,
      this.darkMode = false,
      this.height = 85,
      this.subtitle = "",
      this.leadingColor = Colors.black,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userStateAuth);
    return authState.when(
        data: (data) {
          if (data != null) {
            return Scaffold(
              bottomNavigationBar: bottomNav,
              extendBody: true,
              backgroundColor: bgColor,
              appBar: AppBar(
                  excludeHeaderSemantics: true,
                  toolbarHeight: height,
                  backgroundColor: bgColor,
                  leadingWidth: isWithBackButton ? 50 : 0,
                  leading: isWithBackButton
                      ? Platform.isAndroid
                          ? GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration:
                                    const BoxDecoration(shape: BoxShape.circle),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: leadingColor,
                                  size: 26,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: leadingColor,
                                size: 26,
                              ),
                            )
                      : Container(),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // isWithBackButton
                      //     ? GestureDetector(
                      //         onTap: () => Navigator.pop(context),
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(right: 22.0),
                      //           child: Image.asset(
                      //             "assets/icons/back_button.png",
                      //             width: 17,
                      //           ),
                      //         ),
                      //       )
                      //     : Container(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: TextDirection.ltr,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: isWithBackButton ? 18 : 22,
                                  color: textColor),
                            ),
                            isCustomWidget
                                ? customWidget
                                : subtitle.isNotEmpty
                                    ? Text(
                                        subtitle,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.black54),
                                      )
                                    : Container(),
                          ],
                        ),
                      ),
                      rightWidget,
                    ],
                  ),
                  centerTitle: false),
              body: Container(
                height: double.infinity,
                decoration: boxDecoration,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: body,
                ),
              ),
            );
          }
          return FirstTimeAuth(isWithBackButton: isWithBackButton);
        },
        error: (_, __) => const Text("error"),
        loading: () => const Text("loading"));
  }
}
