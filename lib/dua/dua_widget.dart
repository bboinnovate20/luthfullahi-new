import 'dart:async';

import 'package:babaloworo/local_resource/dua/dua_bus_logic.dart';
import 'package:babaloworo/quran/quran_reading_widget.dart';
import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:babaloworo/shared/search.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dua extends StatefulWidget {
  const Dua({super.key});

  @override
  State<Dua> createState() => _DuaState();
}

class _DuaState extends State<Dua> {
  List listOfDua = [];
  List filteredList = [];
  Timer timer = Timer(Duration.zero, () => {});

  getList() async {
    final dua = DuaUtil();
    final result = await dua.getDuaList();

    setState(() {
      listOfDua = result;
    });
  }

  filterSearch(String value) async {
    timer.cancel();
    timer = Timer(const Duration(milliseconds: 100), () async {
      final dua = DuaUtil();
      final result = await dua.filterList(value);

      if (result.isNotEmpty) {
        setState(() {
          filteredList = result;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: "Dua & Dhikr (Prayer & Rememberance)",
        body: Column(
          children: [
            SearchCard(onSearch: (value) => {filterSearch(value)}),
            if (filteredList.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final element = filteredList[index];
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: element['listing'].length,
                      itemBuilder: (context, listIndex) {
                        return ListCard(
                          title: element['listing'][listIndex]['content'],
                          subtitle: element['name'],
                          action: () => {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: NavigatorNamed.duaMainListing(
                                  title: element['listing'][listIndex]
                                      ['content'],
                                  subtitle:
                                      "Dua & Dhikr (Prayer & Rememberance)",
                                  listId: element['listing'][listIndex]['id'],
                                ),
                                withNavBar: false)
                          },
                        );
                      },
                    );
                  },
                ),
              )
            else if (listOfDua.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOfDua.length,
                  itemBuilder: (context, index) {
                    return ListCard(
                      title: listOfDua[index]['name'],
                      action: () => {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: NavigatorNamed.duaListing(
                                title: listOfDua[index]['name'],
                                id: listOfDua[index]['id']),
                            withNavBar: false)
                      },
                    );
                  },
                ),
              )
            else
              Container(),
          ],
        ));
  }
}

class DuaEachList extends StatefulWidget {
  final int id;
  final String title;
  const DuaEachList({super.key, required this.id, required this.title});

  @override
  State<DuaEachList> createState() => _DuaEachListState();
}

class _DuaEachListState extends State<DuaEachList> {
  Map duaEachList = {};

  initiateList() async {
    final list = DuaUtil();
    final result = await list.duaListing(widget.id);

    setState(() {
      duaEachList = result;
    });
  }

  @override
  void initState() {
    super.initState();
    initiateList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: widget.title,
        subtitle: "Dua & Dhikr (Prayer & Rememberance)",
        body: duaEachList.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 15),
                child: ListView.builder(
                    itemCount: duaEachList['listing'].length,
                    itemBuilder: (context, index) {
                      return ListCard(
                          title: duaEachList['listing'][index]['content'],
                          action: () => {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: NavigatorNamed.duaMainListing(
                                        title: duaEachList['listing'][index]
                                            ['content'],
                                        subtitle: widget.title,
                                        listId: duaEachList['listing'][index]
                                            ['id'],
                                        mainId: widget.id),
                                    withNavBar: false)
                              });
                    }),
              )
            : Container());
  }
}

class DuaMain extends StatefulWidget {
  final int listId;
  final int mainId;
  final String title;
  final String subtitle;
  const DuaMain(
      {super.key,
      required this.listId,
      required this.mainId,
      required this.title,
      required this.subtitle});

  @override
  State<DuaMain> createState() => _DuaMainState();
}

class _DuaMainState extends State<DuaMain> {
  List mainDua = [];
  getList() async {
    final dua = DuaUtil();
    final result = await dua.duaMainListing(widget.listId);
    setState(() {
      mainDua = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: widget.title,
        subtitle: widget.subtitle,
        body: mainDua.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: mainDua.length,
                          itemBuilder: (context, index) {
                            return DuaCard(
                              translation: mainDua[index]['translation'] ?? "",
                              transliteration:
                                  mainDua[index]['transliteration'] ?? "",
                              arabic: mainDua[index]['arabic_text'] ?? "",
                            );
                          }),
                    )
                  ],
                ),
              )
            : Container());
  }
}

class DuaCard extends StatelessWidget {
  final String arabic;
  final String transliteration;
  final String translation;

  const DuaCard({
    super.key,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShareVerse(
                    message: {
                      'arabic': arabic,
                      'transliteration': transliteration,
                      'english': translation
                    },
                    quote: 'Daily Dua',
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: ArabicText(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        arabic: arabic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  transliteration,
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 22),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    translation,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
