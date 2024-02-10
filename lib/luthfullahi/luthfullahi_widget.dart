import 'package:babaloworo/local_resource/luthfullahi.dart';
import 'package:babaloworo/luthfullahi/luthfullahi_prayer_book_list.dart';
import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/navigation.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LuthfullahiResource extends StatelessWidget {
  const LuthfullahiResource({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        title: "Luthfullahi E-Resources",
        subtitle:
            "This resources is compiled by Luthfullahi Society of Nigeria",
        body: Container(
          margin: const EdgeInsets.only(top: 30),
          child: ListView.builder(
              itemCount: luthfullahiResource.length,
              itemBuilder: (context, index) => ListCard(
                    action: () => PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: NavigatorNamed.luthfullahi,
                        withNavBar: false),
                    title: luthfullahiResource[index]["title"]!,
                    iconName: luthfullahiResource[index]["iconName"]!,
                    iconColor:
                        luthfullahiResource[index]["name"] == "updated_prayer"
                            ? Colors.black
                            : Theme.of(context).colorScheme.primary,
                    bgColor:
                        luthfullahiResource[index]["name"] == "updated_prayer"
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                  )),
        ));
  }
}
