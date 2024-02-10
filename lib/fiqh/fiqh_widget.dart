import 'package:babaloworo/local_resource/fiqh/fiqh_bus_logic.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:babaloworo/shared/search.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Fiqh extends StatefulWidget {
  const Fiqh({super.key});

  @override
  State<Fiqh> createState() => _FiqhState();
}

class _FiqhState extends State<Fiqh> {
  List fiqhList = [];

  getFiqhList() async {
    final fiqh = FiqhUtil();
    final result = await fiqh.getFiqhList();

    setState(() {
      fiqhList = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getFiqhList();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: "Fiqh (Islamic Shari’ah)",
        body: fiqhList.isNotEmpty
            ? Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: const Text(
                      "These contents for Islamic educational purpose ONLY and may be subject to error occur during manual or technical compilation, you can contact the admin for any complaint or support . Jazakumullahu Khairan",
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: fiqhList.length,
                        itemBuilder: (context, index) {
                          return ListCard(
                              title: fiqhList[index]['topic'],
                              action: () => {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: NavigatorNamed.fiqhListing(
                                            title: fiqhList[index]['topic'],
                                            id: fiqhList[index]['id']),
                                        withNavBar: false)
                                  });
                        }),
                  )
                ],
              )
            : Container());
  }
}

class FiqhEachList extends StatefulWidget {
  final int id;
  final String title;
  const FiqhEachList({super.key, required this.id, this.title = ""});

  @override
  State<FiqhEachList> createState() => _FiqhEachListState();
}

class _FiqhEachListState extends State<FiqhEachList> {
  Map fiqhEachListing = {};

  getEachListing() async {
    final fiqhList = FiqhUtil();
    final result = await fiqhList.getSingleFiqListing(widget.id);

    setState(() {
      fiqhEachListing = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getEachListing();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: fiqhEachListing['topic'] ?? "",
        subtitle: "Fiqh (Islamic Shari’ah)",
        body: fiqhEachListing.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: fiqhEachListing['subtopic'].length,
                        itemBuilder: (context, index) {
                          return ListCard(
                              title: fiqhEachListing['subtopic'][index]
                                      ['name'] ??
                                  "",
                              action: () => {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: NavigatorNamed.fiqhMainListing(
                                            title: widget.title,
                                            mainId: fiqhEachListing['subtopic']
                                                [index]['id'],
                                            listId: widget.id),
                                        withNavBar: false)
                                  });
                        }),
                  )
                ],
              )
            : Container());
  }
}

class MainFiqhContent extends StatefulWidget {
  final int listId;
  final int mainId;
  final String parentTitle;

  const MainFiqhContent(
      {super.key,
      required this.listId,
      required this.mainId,
      this.parentTitle = ""});

  @override
  State<MainFiqhContent> createState() => _MainFiqhContentState();
}

class _MainFiqhContentState extends State<MainFiqhContent> {
  List fiqhList = [];
  getList() async {
    final fiqh = FiqhUtil();
    final result = await fiqh.getMainContent(widget.listId, widget.mainId);
    setState(() {
      fiqhList = result;
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
        title: fiqhList.isNotEmpty ? fiqhList[0]['name'] : "",
        subtitle: widget.parentTitle,
        body: fiqhList.isEmpty
            ? Container()
            : ListView.builder(
                itemCount: fiqhList.length,
                itemBuilder: (context, index) {
                  return FiqhContentCard(
                      topic: fiqhList[index]['name'],
                      content: fiqhList[index]['content']);
                }));
  }
}

class FiqhContentCard extends StatelessWidget {
  final String topic;
  final String content;
  const FiqhContentCard(
      {super.key, required this.topic, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Text(
                    topic,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Icon(Icons.share_outlined)
              ],
            ),
          ),
          Text(
            content,
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(height: 1.5),
          ),
          const Divider(
            height: 15,
            color: Colors.black26,
            thickness: 1,
          )
        ],
      ),
    );
  }
}
