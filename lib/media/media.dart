import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';

class Media extends StatefulWidget {
  const Media({super.key});

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        title: "Media",
        isWithBackButton: true,
        body: GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          crossAxisCount: 2,
          children: const [MediaCard(), MediaCard(), MediaCard()],
        ));
  }
}

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFFFFA8D),
          borderRadius: BorderRadius.circular(15)),
      child: Center(
          child: Image.asset(
        "assets/images/youtube.png",
        width: 30,
        height: 30,
      )),
    );
  }
}
