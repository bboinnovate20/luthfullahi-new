import 'dart:convert';

import 'package:babaloworo/local_resource/quran/quran_bus_logic.dart';
import 'package:babaloworo/main.dart';
import 'package:babaloworo/quran/quran_reading_widget.dart';
import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/basic_util.dart';
import 'package:babaloworo/shared/download_surah.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/quran_reciter.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ReciterNotifier extends ChangeNotifier {
  int currentReciterId = 1;

  changeReciter(int id) {
    currentReciterId = id;
    notifyListeners();
  }
}

class Quran extends StatelessWidget {
  final bool isWithBackButton;
  const Quran({super.key, this.isWithBackButton = false});

  @override
  Widget build(BuildContext context) {
    // directory();
    return ScaffoldContainer(
      title: "Quran",
      isCustomWidget: true,
      isWithBackButton: isWithBackButton,
      customWidget: const DropDownReciters(),
      body: const QuranTabs(),
    );
  }
}

class QuranTabs extends StatelessWidget {
  const QuranTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        animationDuration: const Duration(milliseconds: 500),
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: const TabBarView(
            children: <Widget>[
              AllSurahs(),
              AllBookmarked(),
            ],
          ),
          appBar: AppBar(
            titleSpacing: 0,
            toolbarHeight: 3,
            // title: const Divider(
            //   color: Colors.black12,
            //   thickness: 2,
            //   height: 25,
            // ),
            bottom: TabBar(
              padding: const EdgeInsets.all(0),
              dividerColor: const Color.fromRGBO(0, 0, 0, 0),
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              unselectedLabelColor: Colors.black,
              labelColor: Theme.of(context).colorScheme.secondary,
              labelStyle: Theme.of(context).textTheme.titleMedium,
              tabs: const <Widget>[
                Tab(
                  text: "All Surahs",
                ),
                Tab(
                  text: "Bookmark Verses",
                ),
              ],
            ),
          ),
        ));
  }
}

class AllBookmarked extends ConsumerStatefulWidget {
  const AllBookmarked({
    super.key,
  });

  @override
  ConsumerState<AllBookmarked> createState() => _AllBookmarkedState();
}

class _AllBookmarkedState extends ConsumerState<AllBookmarked> {
  List bookmarkedAyah = [];

  getReference(int id) async {
    final getReference = QuranUtil();
    final surahs = await getReference.getOnlySurah();

    final getSpecific = surahs.where((element) => element.verse == id).first;

    return getSpecific;
  }

  getBookmarkedLists() async {
    final storage = SecuredStorage();

    // try {
    final result = await storage.readData(key: "bookmarks");
    final resultList = jsonDecode(result);
    for (var i = 0; i < resultList.length; i++) {
      if (resultList[i].isNotEmpty) {
        final ref = await getReference(resultList[i]['surah']);
        resultList[i]['transliteration'] = ref.arabic;
        resultList[i]['translation'] = ref.english;
      }
    }
    setState(() {
      bookmarkedAyah = resultList;
    });
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
  }

  @override
  void initState() {
    super.initState();
    getBookmarkedLists();
  }

  @override
  Widget build(BuildContext context) {
    return bookmarkedAyah.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: bookmarkedAyah.length,
            itemBuilder: (context, index) => bookmarkedAyah[index].isEmpty
                ? Container()
                : EachSurahCard(
                    id: "V-${bookmarkedAyah[index]["verse"]!}",
                    title: bookmarkedAyah[index]["transliteration"]!,
                    subtitle: bookmarkedAyah[index]["translation"]!,
                    action: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: NavigatorNamed.surahReading(
                            reciterId:
                                ref.watch(quranNotifierProvider).reciterId,
                            verse: bookmarkedAyah[index]['verse'],
                            index: bookmarkedAyah[index]['surah']),
                        withNavBar: false)));
  }
}

class AllSurahs extends ConsumerStatefulWidget {
  const AllSurahs({
    super.key,
  });

  @override
  ConsumerState<AllSurahs> createState() => _AllSurahsState();
}

class _AllSurahsState extends ConsumerState<AllSurahs> {
  List<QuranList> surahList = [];
  int currentReciterId = 1;

  getDataList() async {
    final QuranUtil listVerse = QuranUtil();
    final List<QuranList> result = await listVerse.getOnlySurah();
    setState(() {
      surahList = result;
    });
  }

  @override
  void initState() {
    super.initState();

    getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return surahList.isNotEmpty
        ? ListView.builder(
            itemCount: surahList.length,
            itemBuilder: (context, index) {
              return EachSurahCard(
                id: formatNumber(surahList[index].verse, 3),
                title: surahList[index].arabic,
                subtitle: surahList[index].english,
                action: () => PersistentNavBarNavigator.pushNewScreen(context,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                    screen: NavigatorNamed.surahReading(
                        reciterId: ref.watch(quranNotifierProvider).reciterId,
                        index: surahList[index].verse),
                    withNavBar: false),
              );
            })
        : Container();
  }
}

class DropDownReciters extends ConsumerWidget {
  const DropDownReciters({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownMenu(
      // expandedInsets: const EdgeInsets.only(left: 2),
      trailingIcon: Image.asset(
        "assets/icons/arrow_down.png",
        width: 9.2,
        height: 6.15,
      ),
      selectedTrailingIcon: Image.asset(
        "assets/icons/arrow_up.png",
        width: 9.2,
        height: 6.15,
      ),
      menuStyle: const MenuStyle(
          fixedSize: MaterialStatePropertyAll(Size.fromHeight(0)),
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          backgroundColor: MaterialStatePropertyAll(Colors.white)),
      initialSelection: 1,
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.zero,
          filled: false,
          outlineBorder: BorderSide.none,
          border: InputBorder.none),
      dropdownMenuEntries: reciters
          .map((reciter) => DropdownMenuEntry(
              value: reciter["id"], label: reciter["name"].toString()))
          .toList(),
      onSelected: (value) {
        ref
            .read(quranNotifierProvider)
            .changeReciter(int.parse(value.toString()));
        // context
        //     .read<ReciterNotifier>()
        //     .changeReciter(int.parse(value.toString()));
      },
    );
  }
}

class EachSurahCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String? arabicImagePath;
  final Function action;
  final Widget? sideIcon;
  final double height;
  final Widget? rightWidget;
  final String subSubTitle;
  const EachSurahCard(
      {super.key,
      required this.id,
      this.rightWidget,
      this.sideIcon,
      this.subSubTitle = "",
      required this.title,
      required this.subtitle,
      required this.action,
      this.height = 76,
      this.arabicImagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        color: Colors.white,
        shadowColor: Colors.black26,
        elevation: 5,
        surfaceTintColor: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraint) {
            return IntrinsicHeight(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: SizedBox(
                  height: double.infinity,
                  child: Row(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10),
                          child: sideIcon ??
                              Text(
                                id,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              textDirection: TextDirection.ltr,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(fontSize: 17),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  subtitle,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 17),
                                ),
                                subSubTitle.isNotEmpty
                                    ? Text(
                                        subSubTitle,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: rightWidget ??
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SurahNames(
                                fontWeight: FontWeight.normal,
                                arabic: id.toString(),
                                fontSize: 32,
                                color: Colors.black,
                              ),
                            ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
