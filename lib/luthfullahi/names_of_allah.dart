import 'package:babaloworo/quran/quran_widget.dart';
import 'package:babaloworo/shared/arabic_text.dart';
import 'package:babaloworo/shared/basic_util.dart';
import 'package:babaloworo/shared/json_converter.dart';
import 'package:flutter/material.dart';

class NamesOfAllah extends StatefulWidget {
  const NamesOfAllah({
    super.key,
  });

  @override
  State<NamesOfAllah> createState() => _NamesOfAllahState();
}

class _NamesOfAllahState extends State<NamesOfAllah> {
  List content = [];
  getData() async {
    final convert = await loadJSONFile(
        "assets/resources/luthfullahi_e_resource/names_of_allah.json");

    setState(() {
      content = convert;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? Container()
        : ListView.builder(
            itemBuilder: (context, index) {
              return EachSurahCard(
                id: "${formatNumber(index + 1, 2)}",
                rightWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ArabicText(
                    arabic: content[index]['name'],
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                    color: Colors.black,
                  ),
                ),
                // sideIcon: ArabicText(arabic: content[index]['name']),
                title: content[index]['transliteration'],
                subtitle: content[index]['en']['meaning'],
                subSubTitle:
                    "Small: ${content[index]['smallNumeric']} | Big: ${content[index]['bigNumeric']}",
                action: () => {},
                height: 80, // arabicImagePath: "001.png",
              );
            },
            itemCount: content.length);
  }
}
