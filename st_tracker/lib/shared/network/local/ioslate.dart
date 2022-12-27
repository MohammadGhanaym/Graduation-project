import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';

class MyIsolate {
  static void isolate(String arg) async {
    print('start ioslate');
    WidgetsFlutterBinding.ensureInitialized();
    CacheHelper.init();
    await Firebase.initializeApp();
    print('before studentID');
    studentID = CacheHelper.getData(key: 'st_id');
    print('after studentID');
    // For flutter prior to version 3.0.0
    // We have to register the plugin manually
    /// OPTIONAL when use custom notification

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var androidInit = const AndroidInitializationSettings('mipmap/logo');
    var IOSInit = const DarwinInitializationSettings();
    var settingsInit =
        InitializationSettings(android: androidInit, iOS: IOSInit);

    await flutterLocalNotificationsPlugin.initialize(settingsInit);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('channelId', 'channelName',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);

    var notify = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    /*await flutterLocalNotificationsPlugin.show(
        0, 'Purchase', 'notify_body', notify);*/

    FirebaseFirestore.instance
        .collection('canteen transactions')
        .doc(studentID)
        .collection('transactions')
        .snapshots()
        .listen((event) {
      event.docs.forEach((trans) {
        trans['products'].forEach((product) async {
          String notify_body =
              'from isolate ${product['name']}      -${product['price']} EGP      ${DateFormat('EE, hh:mm a').format(DateTime.now())}';

          await flutterLocalNotificationsPlugin.show(
              0, 'Purchase', notify_body, notify);
        });
      });
    });
  }
}
