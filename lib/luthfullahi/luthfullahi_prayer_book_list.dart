import 'package:babaloworo/shared/list_card.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';

class PrayerBookList extends StatelessWidget {
  const PrayerBookList({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      isWithBackButton: true,
      title: "Prayer Book",
      body: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListCard(
              fontWeight: FontWeight.bold,
              isGradient: true,
              title: "99 Names of Allah",
              action: () => {}),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Main Adkar",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.black54),
            ),
          ),
          ListCard(
              isGradient: true,
              fontWeight: FontWeight.bold,
              subtitle: "Compiled by: Sheikh Rabiu Adebayo",
              title: "99 Names of Allah",
              action: () => {})
        ],
      ),
    );
  }
}
