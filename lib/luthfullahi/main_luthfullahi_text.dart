import 'dart:ui';

import 'package:babaloworo/shared/json_converter.dart';
import 'package:flutter/material.dart';

class MainLuthfullahiContentText extends StatefulWidget {
  final String fileName;
  const MainLuthfullahiContentText({super.key, required this.fileName});

  @override
  State<MainLuthfullahiContentText> createState() =>
      _MainLuthfullahiContentTextState();
}

class _MainLuthfullahiContentTextState
    extends State<MainLuthfullahiContentText> {
  Map content = {};
  int activePart = 1;
  initiateContent() async {
    final contentR = await loadJSONFile(
        "assets/resources/luthfullahi_e_resource/${widget.fileName}.json");
    setState(() {
      content = contentR;
    });
  }

  @override
  void initState() {
    super.initState();
    initiateContent();
  }

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? Container()
        : Column(
            children: [
              SectionNavigationButton(
                  onTap: (index) => {
                        setState(() {
                          activePart = index;
                        })
                      },
                  activeIndex: activePart - 1,
                  length: content['content'].length ?? 0),
              Expanded(
                  child: LuthfullahiTextContent(
                title: content['content'][activePart - 1]['name'],
                isSingle: content['content'][activePart - 1]['id'] == 0,
                content: content['content'][activePart - 1]['content'],
              ))
            ],
          );
  }
}

class LuthfullahiTextContent extends StatelessWidget {
  final List content;
  final String title;
  final bool isSingle;
  const LuthfullahiTextContent(
      {super.key,
      required this.content,
      required this.title,
      required this.isSingle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 10),
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: isSingle
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SingleChildScrollView(
                    child: Text(content[0],
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(height: 1.5)),
                  ),
                )
              : ListView.builder(
                  itemCount: content.length,
                  itemBuilder: (_, index) {
                    return MainText(
                      transliteration: content[index]['transliteration'] ?? "",
                      english: content[index]['translation'] ?? "",
                    );
                  }),
        )
      ],
    );
  }
}

class MainText extends StatelessWidget {
  final String transliteration;
  final String english;

  const MainText({
    super.key,
    required this.transliteration,
    required this.english,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          child: Text(
            transliteration,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        Text(
          english,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 17),
        ),
      ],
    );
  }
}

class SectionNavigationButton extends StatelessWidget {
  final int length;
  final Function onTap;
  final int activeIndex;
  const SectionNavigationButton(
      {super.key,
      required this.length,
      required this.onTap,
      required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTap(index + 1),
            child: Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    color: activeIndex == index
                        ? Theme.of(context).colorScheme.secondary
                        : const Color(0xFFF2CFFF),
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 17),
                  child: Text(
                    "Part ${index + 1}",
                    style: TextStyle(
                        color:
                            activeIndex == index ? Colors.white : Colors.black),
                  ),
                )),
          );
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
