import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';

class BackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    /// OPTIONAL, using custom notification channel id
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'my_foreground',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,
      ),
    );

    service.startService();
  }

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    CacheHelper.init();
    await Firebase.initializeApp();
    studentID = CacheHelper.getData(key: 'st_id');

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
        const AndroidNotificationDetails('my_foreground', 'channelName',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);

    var notify = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
        0, 'Purchase', 'notify_body', notify);

    FirebaseFirestore.instance
        .collection('canteen transactions')
        .doc(studentID)
        .collection('transactions')
        .snapshots()
        .listen((event) {
      event.docs.forEach((trans) {
        trans['products'].forEach((product) async {
          String notify_body =
              '${product['name']}      -${product['price']} EGP      ${DateFormat('EE, hh:mm a').format(DateTime.now())}';

          await flutterLocalNotificationsPlugin.show(
              0, 'Purchase', notify_body, notify);
        });
      });
    });
  }
}


/*class BackgroundService {
  static Future<void> initializeService() async {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    await Firebase.initializeApp();
    await CacheHelper.init();
    DioHelper.init();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,
      ),
    );
  }

  static void onStart(ServiceInstance service) async {
    /*FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);*/
    DartPluginRegistrant.ensureInitialized();

    studentID = CacheHelper.getData(key: 'st_id');
    //
    trans_listener = FirebaseFirestore.instance
        .collection('canteen transactions')
        .doc(studentID)
        .collection('transactions')
        .snapshots()
        .listen((event) {
      event.docs.forEach((trans) {
        print('trans received');
        /*DioHelper.sendNotification(
            notification_title: 'Purchase', notification_body: 'notify_body');*/
      });
    });
  }

  /*static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print(message.data.toString());
    print('onBackgroundMessage');
  }*/
}
*/