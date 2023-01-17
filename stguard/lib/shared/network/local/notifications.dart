import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationSerivce {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future notifyInit() async {
    var androidInit = new AndroidInitializationSettings('mipmap/logo');
    var IOSInit = new DarwinInitializationSettings();
    var settingsInit =
        new InitializationSettings(android: androidInit, iOS: IOSInit);

    await flutterLocalNotificationsPlugin.initialize(settingsInit);
  }

  static Future showNotification(
      {var id,
      required String title,
      required String body,
      var payload}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails('channelId', 'channelName',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);

    var notify = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(id, title, body, notify);
  }
}
