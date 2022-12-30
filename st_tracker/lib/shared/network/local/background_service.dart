import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:st_tracker/models/student_model.dart';
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
        isForegroundMode: false,
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
    //studentID = CacheHelper.getData(key: 'st_id');

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually
    /// OPTIONAL when use custom notification

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

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

    if (CacheHelper.getData(key: 'IDsList') != null) {
      IDs = CacheHelper.getData(key: 'IDsList');
      if (IDs.isNotEmpty) {
        IDs.forEach((studentID) {
          sendTransNotification(
              studentID, flutterLocalNotificationsPlugin, notify);
          sendAttendanceNotification(
              studentID, flutterLocalNotificationsPlugin, notify);
        });
      }
    }
  }

  static void sendTransNotification(
      studentID,
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      var notify) {
    FirebaseFirestore.instance
        .collection('canteen transactions')
        .doc(studentID)
        .collection('transactions')
        .snapshots()
        .listen((event) {
      int notify_id = random.nextInt(pow(2, 31).toInt() - 1);
      event.docs.forEach((trans) async {
        String notify_body =
            '-${trans['total_price']}\t\t\t\t${DateFormat('EE, hh:mm a').format(DateTime.now())}';
        FirebaseFirestore.instance
            .collection('students')
            .doc(studentID)
            .get()
            .then((value) async {
          await flutterLocalNotificationsPlugin.show(notify_id,
              '${value['name'].split(' ')[0]} Purchased', notify_body, notify);
        });
      });
    });
  }

  static void sendAttendanceNotification(
      studentID,
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      var notify) {
    if (studentID != null)
      FirebaseFirestore.instance
          .collection('students')
          .doc(studentID)
          .snapshots()
          .listen((event) async {
        int notify_id = random.nextInt(pow(2, 31).toInt() - 1);

        SchoolAttendanceModel attendanceStatus =
            SchoolAttendanceModel.fromJson(event.data()!['attendance status']);
        String notify_body =
            '${DateFormat('EE, hh:mm a').format(DateTime.now())}';

        if (attendanceStatus.arrived) {
          await flutterLocalNotificationsPlugin.show(notify_id,
              '${event['name'].split(' ')[0]} Arrived', notify_body, notify);
        } else if (attendanceStatus.left) {
          await flutterLocalNotificationsPlugin.show(notify_id,
              '${event['name'].split(' ')[0]} Left', notify_body, notify);
        }
      });
  }
}
