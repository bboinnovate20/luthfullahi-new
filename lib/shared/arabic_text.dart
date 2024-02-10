import 'package:flutter/material.dart';

class ArabicText extends StatelessWidget {
  final String arabic;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const ArabicText(
      {super.key,
      this.fontWeight = FontWeight.normal,
      required this.arabic,
      this.fontSize = 25,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Text(
      arabic,
      overflow: TextOverflow.visible,
      textDirection: TextDirection.rtl,
      style: TextStyle(
          fontFamily: "Uthmanic",
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: 1.8,
          color: color),
      textAlign: TextAlign.right,
    );
  }
}

class SurahNames extends ArabicText {
  const SurahNames(
      {super.key,
      required String arabic,
      required double fontSize,
      required Color? color,
      required FontWeight fontWeight})
      : super(arabic: arabic, fontSize: fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      arabic,
      style: TextStyle(
          fontFamily: "SurahNames",
          fontSize: fontSize,
          fontWeight: super.fontWeight,
          height: 1.8,
          color: super.color),
      textAlign: TextAlign.right,
    );
  }
}
