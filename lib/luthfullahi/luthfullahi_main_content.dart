import 'package:babaloworo/luthfullahi/main_luthfullahi_text.dart';
import 'package:babaloworo/luthfullahi/names_of_allah.dart';
import 'package:babaloworo/quran/quran_widget.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LuthfullahiList extends StatelessWidget {
  const LuthfullahiList({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      title: "Luthfullahi Prayer Book",
      subtitle: "By Sheikh Rabiu Adebayo",
      isWithBackButton: true,
      body: ListView.builder(
          itemCount: luthfullahiMainContents.length,
          itemBuilder: (_, index) => ListCard(
                action: () => {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: NavigatorNamed.luthfullahiMain(id: index),
                      withNavBar: false)
                },
                title: luthfullahiMainContents[index][0],
              )),
    );
  }
}

class LuthfullahiCard extends StatelessWidget {
  const LuthfullahiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF62007B), Color(0xFFC235ED)]),
          // image: const DecorationImage(
          //     scale: 1,
          //     alignment: Alignment.bottomRight,
          //     image: AssetImage('assets/images/prayer_background.jpg'),
          //     fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          child: Text(
            "Prayer Book Updated",
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class LuthfullahiMain extends StatefulWidget {
  final int initialIndex;
  const LuthfullahiMain({super.key, this.initialIndex = 0});

  @override
  State<LuthfullahiMain> createState() => _LuthfullahiMainState();
}

class _LuthfullahiMainState extends State<LuthfullahiMain> {
  int next(int index, int total) {
    if (index < total) return index + 1;
    return index;
  }

  int prev(int index, total) {
    if (index > 0 && index <= total) return index - 1;
    return index;
  }

  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if (widget.initialIndex <= luthfullahiMainContents.length - 1) {
        selectedIndex = widget.initialIndex;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      isWithBackButton: true,
      title: "Luthfullahi Prayer Book ",
      subtitle: "By Sheikh Rabiu Adebayo",
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      int prevIndex = prev(
                          selectedIndex, luthfullahiMainContents.length - 1);
                      setState(() {
                        selectedIndex = prevIndex;
                      });
                    },
                    child: Text(
                      "< Prev",
                      style: TextStyle(
                          color:
                              selectedIndex <= 0 ? Colors.grey : Colors.black),
                    )),
                Expanded(
                    child: Text(
                  luthfullahiMainContents[selectedIndex][0],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                )),
                GestureDetector(
                    onTap: () {
                      int nextIndex = next(
                          selectedIndex, luthfullahiMainContents.length - 1);

                      setState(() {
                        selectedIndex = nextIndex;
                      });
                    },
                    child: Text(
                      "Next >",
                      style: TextStyle(
                          color: selectedIndex >=
                                  luthfullahiMainContents.length - 1
                              ? Colors.grey
                              : Colors.black),
                    ))
              ],
            ),
          ),
          Expanded(child: luthfullahiMainContents[selectedIndex][1])
        ],
      ),
    );
  }
}

List<dynamic> luthfullahiMainContents = [
  [
    "99 Names of Allah",
    const NamesOfAllah(),
  ],
  [
    "Jam'yat Luthfullahi Prayers",
    MainLuthfullahiContentText(
        key: UniqueKey(), fileName: "jammiyat_luthfullahi"),
  ],
  [
    "Fathu Bahri",
    MainLuthfullahiContentText(key: UniqueKey(), fileName: "fathu_bahri"),
  ],
  [
    "Nuniyat Ibn Malik",
    MainLuthfullahiContentText(key: UniqueKey(), fileName: "nuniyat_ibn_malik"),
  ],
  [
    "Spiritual Eficacy of Ahamu Sa Qaku Hala'u Ya Su",
    MainLuthfullahiContentText(
        key: UniqueKey(), fileName: "spiritual_efficacy"),
  ],
];
