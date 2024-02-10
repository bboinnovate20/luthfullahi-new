import 'dart:convert';

import 'package:babaloworo/shared/secured_storage_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Database {
  CollectionReference users = FirebaseFirestore.instance.collection('admins');

  CollectionReference notifications =
      FirebaseFirestore.instance.collection('notifications');

  addUser(UserAuth user) async {
    try {
      await users.add(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  getAdmin(String email) async {
    try {
      final result = await users.doc(email).get();
      print("my result ${result.exists} $email");
      return result.exists;
    } catch (e) {
      return false;
    }
  }

  checkAdmin(UserAuth user) {
    if (user.status == 1) return true;
    return false;
  }

  addNotification(NotificationData notification) async {
    try {
      await notifications.add(notification.toJson());
      //notify all users
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getNotification() {
    return notifications.snapshots();
  }

  deleteNotification(String id) async {
    try {
      await notifications.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}

class UserAuth {
  final String email;
  final String token;
  final int status;
  UserAuth(this.email, this.token, this.status);

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      json['email'] as String,
      json['token'] as String,
      json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'status': status,
    };
  }
}

class NotificationData {
  final String id;
  final String description;
  final String author;
  final String title;
  final DateTime date;

  NotificationData(
      this.id, this.description, this.author, this.title, this.date);

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      json['id'] as String,
      json['description'] as String,
      json['author'] as String,
      json['title'] as String,
      json['date'] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'author': author,
      'title': title,
      'date': date,
    };
  }
}

sendNotification() async {
  // RemoteMessage? initialMessage  = await FirebaseMessaging.instance.getInitialMessage();
  // const message = {
  //   'data': {'score': '850', 'time': '2:45'},
  //   'topic': 'topic'
  // };

  // initialMessage.s
}

initiateMessaging() async {
  final storage = SecuredStorage();
  final getStatus = await storage.readData(key: "notification");

  if (getStatus == null) {
    try {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await FirebaseMessaging.instance.subscribeToTopic('notification');

        storage.writeData("notification", "true");
      }
    } catch (e) {
      rethrow;
    }
  }
}

void sendFCMNotification(String topic) async {
  const String serverKey =
      'AAAAT-QZKTA:APA91bEwAd46mfg2SVyw58wr1CVymnQf6cRUjJlRKZdJe3DYNvkoQKRsF5JeJGz94Z84XfyojvVmJXY77XKMiR4vn1FDB_5DYP4xSTNXCeqZ5o8IL6aKCWFW5QnXsGCJ3fPczifPmqdK'; // Replace with your FCM server key
  const String endpoint = 'https://fcm.googleapis.com/fcm/send';

  final Map<String, dynamic> requestData = {
    "to": "/topics/notification",
    "notification": {
      "title": topic,
      "body": "Salam Alaykum, Check out the new notification ",
      "apns": {
        "payload": {
          "aps": {"category": "NEW_MESSAGE_CATEGORY"}
        }
      }
    }
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  try {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(requestData));

    if (response.statusCode == 200) {
      print('FCM Notification sent successfully');
    } else {
      print(
          'Failed to send FCM Notification. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print(e);
    print('$e errrorr Error sending');
  }
}
