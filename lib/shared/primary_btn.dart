import 'dart:io';

import 'package:babaloworo/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrimaryButton extends ConsumerWidget {
  final String icon;
  final String title;
  final Function action;
  final bool isLoading;
  final IconData? iconData;
  const   PrimaryButton(
      {super.key,
      this.icon = "",
      this.iconData,
      required this.title,
      required this.action,
      this.isLoading = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => {if (!isLoading) action()},
      child: Container(
        decoration: BoxDecoration(
            border: const Border(
              bottom: BorderSide(width: 4, color: Colors.black),
              right: BorderSide(width: 4, color: Colors.black),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: isLoading
                ? Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Platform.isAndroid ? const CircularProgressIndicator(color: Colors.black) : const CupertinoActivityIndicator(color: Colors.black)),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon.isEmpty
                          ? iconData != null ?  Icon(iconData, color: Colors.black) : Container()
                          : Image.asset(icon, width: 12.73, height: 13),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}

class ButtonExtended extends PrimaryButton {
  const ButtonExtended({
    super.key,
    required super.title,
    required super.action,
    required super.icon,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => action(),
      child: Container(
        decoration: BoxDecoration(
            border: const Border(
              top: BorderSide.none,
              bottom: BorderSide(width: 4, color: Colors.black),
              right: BorderSide(width: 4, color: Colors.black),
            ),
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary),
        margin: const EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon.isEmpty
                    ? Container()
                    : Image.asset(icon, width: 19.73, height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("assets/icons/arrow_right.png", height: 13)
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
