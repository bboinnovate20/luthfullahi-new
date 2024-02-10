import 'package:babaloworo/shared/screen_container.dart';
import 'package:flutter/material.dart';

class NotificationViewer extends StatelessWidget {
  const NotificationViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: "Eid-il-Fitri Notification",
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("By: Management | 9th April 2023"),
            const Divider(color: Colors.black12, height: 30),
            Text(
              "The management announce the eid-il-fitri notification and there will be no Asalatu on that day. Please be informed that. The management announce the eid-il-fitri notification and there will be no Asalatu on that day. Please be informed that",
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ));
  }
}
