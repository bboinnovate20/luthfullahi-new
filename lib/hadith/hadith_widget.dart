import 'dart:async';

import 'package:babaloworo/local_resource/hadith.dart';
import 'package:babaloworo/local_resource/hadith/hadith_bus_logic.dart';
import 'package:babaloworo/quran/quran_reading_widget.dart';
import 'package:babaloworo/quran/quran_widget.dart';
import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:babaloworo/shared/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Hadith extends StatefulWidget {
  final bool isWithBackButton;
  const Hadith({super.key, this.isWithBackButton = false});

  @override
  State<Hadith> createState() => _HadithState();
}

class _HadithState extends State<Hadith> {
  List hadithList = [];

  getHadith() async {
    final hadith = HadithUtil();
    final result = await hadith.getHadithList();
    setState(() {
      hadithList = [...result];
    });
  }

  @override
  void initState() {
    super.initState();
    getHadith();
  }

  @override
  Widget build(BuildContext context) {
    if (hadithList.isEmpty) {
      return Container();
    } else {
      return ScaffoldContainer(
          title: "Hadith",
          isWithBackButton: widget.isWithBackButton,
          body: ListView.builder(
              itemCount: hadithList.length,
              itemBuilder: (context, index) {
                return EachSurahCard(
                    id: "$index",
                    height: 60,
                    sideIcon: Image.asset(
                      "assets/icons/open_book_outline_white.png",
                      width: 24,
                    ),
                    title: hadithList[index]["collection"]!,
                    subtitle: hadithList[index]["author"]!,
                    arabicImagePath: "001.png",
                    action: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: NavigatorNamed.specificHadithList(
                            bookId: hadithList[index]['id']),
                        withNavBar: false));
              }));
    }
  }
}

class EachHadithList extends StatefulWidget {
  final int bookId;
  const EachHadithList({super.key, this.bookId = 1});

  @override
  State<EachHadithList> createState() => _EachHadithListState();
}

class _EachHadithListState extends State<EachHadithList> {
  Map metaData = {};
  Map books = {};
  List filteredBook = [];

  Timer timer = Timer(Duration.zero, () => {});

  getList(int id) async {
    final hadith = HadithUtil();
    final result = await hadith.getCollection(id);
    final resultBooks = await hadith.getBookForSingleHadith(id);
    setState(() {
      metaData = result;
      books = resultBooks;
    });
  }

  filterSearch(String value) {
    timer.cancel();
    timer = Timer(const Duration(milliseconds: 100), () {
      final result = books['books'].where((element) => element['name']
          .toString()
          .toLowerCase()
          .contains(value.toLowerCase()));

      if (result.isNotEmpty) {
        setState(() {
          filteredBook = result.toList();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getList(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        title: metaData['collection'] ?? "",
        subtitle: metaData['author'] ?? "",
        isWithBackButton: true,
        body: filteredBook.isNotEmpty
            ? Column(
                children: [
                  SearchCard(onSearch: (value) => {filterSearch(value)}),
                  Expanded(
                      child: ListView.builder(
                          itemCount: filteredBook.length,
                          itemBuilder: (context, index) {
                            return ListCard(
                                title: filteredBook[index]["name"]!,
                                subtitle: filteredBook[index]['arabic_name'],
                                action: () =>
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen:
                                            NavigatorNamed.mainHadithContent(
                                                bookId: filteredBook[index]
                                                    ['id'],
                                                collection: books['collection'],
                                                title: filteredBook[index]
                                                    ["name"]!,
                                                author: metaData['author']),
                                        withNavBar: false));
                          }))
                ],
              )
            : books.isNotEmpty
                ? Column(
                    children: [
                      SearchCard(onSearch: (value) => filterSearch(value)),
                      Expanded(
                          child: ListView.builder(
                              itemCount: books['books'].length ?? 0,
                              itemBuilder: (context, index) {
                                return ListCard(
                                    title: books['books'][index]["name"]!,
                                    subtitle: books['books'][index]
                                        ['arabic_name'],
                                    action: () =>
                                        PersistentNavBarNavigator.pushNewScreen(
                                            context,
                                            screen: NavigatorNamed
                                                .mainHadithContent(
                                                    bookId: books['books']
                                                        [index]['id'],
                                                    collection:
                                                        books['collection'],
                                                    title: books['books'][index]
                                                        ["name"]!,
                                                    author: metaData['author']),
                                            withNavBar: false));
                              }))
                    ],
                  )
                : Container());
  }
}

class MainHadithContent extends StatefulWidget {
  final int bookId;
  final String collection;
  final String title;
  final String author;
  const MainHadithContent(
      {super.key,
      required this.bookId,
      required this.collection,
      required this.author,
      required this.title});

  @override
  State<MainHadithContent> createState() => _MainHadithContentState();
}

class _MainHadithContentState extends State<MainHadithContent> {
  String title = "";
  String author = "";
  List mainContent = [];

  init() {
    setState(() {
      title = widget.title;
      author = widget.author;
    });

    getContent();
  }

  getContent() async {
    final initiate = HadithUtil();
    final result =
        await initiate.getMainContent(widget.bookId, widget.collection);

    setState(() {
      mainContent = result['hadiths'].toList();
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        title: title ?? "",
        isWithBackButton: true,
        subtitle: author ?? "",
        body: mainContent.isNotEmpty
            ? Container(
                child: ListView.builder(
                    itemCount: mainContent.length,
                    itemBuilder: (context, index) {
                      return HadithCard(
                        bookName:
                            "-$author | $title | ${mainContent[index]["chapter"]}",
                        headingArabic:
                            mainContent[index]["arabic_chapter_title"] ?? "",
                        headingEnglish:
                            mainContent[index]["chapter_title"] ?? "",
                        mainArabic: mainContent[index]["arabic_text"] ?? "",
                        mainEnglish:
                            "${mainContent[index]["text"]} - (Chapter: ${mainContent[index]["chapter"]})" ??
                                "",
                      );
                    }),
              )
            : Container());
  }
}

class HadithCard extends StatelessWidget {
  final String headingArabic;
  final String headingEnglish;
  final String mainArabic;
  final String mainEnglish;
  final String bookName;

  const HadithCard(
      {super.key,
      required this.headingArabic,
      required this.headingEnglish,
      required this.bookName,
      required this.mainArabic,
      required this.mainEnglish});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.black)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ArabicText(
                    fontWeight: FontWeight.bold,
                    arabic: headingArabic,
                    fontSize: 20,
                  ),
                  Text(headingEnglish)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShareVerse(message: {
                        'arabic': mainArabic,
                        'english': mainEnglish,
                        'transliteration': bookName
                      }, quote: "Hadith"),
                      Expanded(
                        child: ArabicText(
                          fontSize: 22,
                          arabic: mainArabic,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(mainEnglish,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(height: 1.5))
              ],
            ),
          )
        ],
      ),
    );
  }
}
