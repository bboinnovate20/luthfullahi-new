import 'package:babaloworo/shared/notification_database.dart';
import 'package:babaloworo/shared/screen_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationState();
}

class _NotificationState extends ConsumerState<NotificationScreen> {
  Stream<QuerySnapshot> getNotification() {
    final db = Database();
    return db.getNotification();
  }

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: "Notification",
        subtitle: "Get all notification from Luthfullahi",
        body: StreamBuilder<QuerySnapshot>(
            stream: getNotification(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              // return;
              List<NotificationData> myData =
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                try {
                  Map<String, dynamic>? data =
                      document.data() as Map<String, dynamic>? ?? {};
                  data['id'] = document.id ?? "122";

                  if (data['date'] != null) {
                    data['date'] = (data['date'] as Timestamp).toDate();
                  }

                  final NotificationData notifyData =
                      NotificationData.fromJson(data);
                  return notifyData;
                } catch (e) {
                  return NotificationData(
                      "",
                      "",
                      "",
                      "",
                      DateTime
                          .now()); // Assuming NotificationData has a default constructor
                }
              }).toList();

              myData.sort((a, b) => b.date.compareTo(a.date));

              return ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(notifyData: myData[index]);
                  });
            }));
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notifyData;
  const NotificationCard({super.key, required this.notifyData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: NotificationMainContent(
                title: notifyData.title,
                description: notifyData.description,
                author: notifyData.author),
            withNavBar: false)
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset.zero,
                  blurRadius: 4,
                  spreadRadius: 5)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Image.asset("assets/icons/bell.png",
                            width: 15, height: 15)),
                    Text(
                      notifyData.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Text(
                textAlign: TextAlign.left,
                notifyData.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(color: Colors.black12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('d MMMM y')
                      .format(notifyData.date)
                      .toString()),
                  const Text("View >")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationMainContent extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  const NotificationMainContent(
      {super.key,
      required this.title,
      required this.description,
      required this.author});

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
        isWithBackButton: true,
        title: title,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                      style: Theme.of(context).textTheme.displayMedium,
                      "By $author"),
                ),
                const Divider(color: Colors.black26, height: 12),
                Text(
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 22),
                    description),
              ],
            ),
          ),
        ));
  }
}
