import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
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
      'child_activity', // id
      'Activity Channel', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high, // importance must be at low or higher level
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    /*
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
        ),
      );
    }*/

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
        autoStartOnBoot: true,
        isForegroundMode: false,
        //notificationChannelId: 'child_activity',
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

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    var androidInit = const AndroidInitializationSettings('mipmap/ic_launcher');
    var IOSInit = const DarwinInitializationSettings();
    var settingsInit =
        InitializationSettings(android: androidInit, iOS: IOSInit);

    await flutterLocalNotificationsPlugin.initialize(settingsInit);

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails('child_activity', 'Activity Channel',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);

    var notify = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    print('*****Background Service On*****');
    userID = CacheHelper.getData(key: 'id');

    await FirebaseFirestore.instance
        .collection('Parents')
        .doc(userID)
        .collection('Students')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((st) {
          sendTransNotification(st, flutterLocalNotificationsPlugin, notify);
          sendAttendanceNotification(
              st, flutterLocalNotificationsPlugin, notify);
        });
      }
    });
  }

  static void sendTransNotification(
      QueryDocumentSnapshot<Map<String, dynamic>> st,
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      var notify) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('Countries')
        .doc(st['country'])
        .collection('Schools')
        .doc(st['school'])
        .collection('Students')
        .doc(st.id)
        .collection('CanteenTransactions')
        .snapshots()
        .listen((event) {
      if (event.docChanges.isNotEmpty) {
        int notify_id = random.nextInt(pow(2, 31).toInt() - 1);
        event.docChanges.forEach((trans) async {
          if (trans.type == DocumentChangeType.added) {
            String notify_body =
                '-${trans.doc['total_price']}\t\t\t\t${DateFormat('EE, hh:mm a').format(DateTime.now())}';
            db
                .collection('Countries')
                .doc(st['country'])
                .collection('Schools')
                .doc(st['school'])
                .collection('Students')
                .doc(st.id)
                .get()
                .then((value) async {
              await flutterLocalNotificationsPlugin.show(
                  notify_id,
                  '${value['name'].split(' ')[0]} Purchased',
                  notify_body,
                  notify);
            }).catchError((error) {
              print(error.toString());
            });
          }
        });
      }
    });
  }

  static void sendAttendanceNotification(
      QueryDocumentSnapshot<Map<String, dynamic>> st,
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      var notify) {
    if (st.exists) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection('Countries')
          .doc(st['country'])
          .collection('Schools')
          .doc(st['school'])
          .collection('Students')
          .doc(st.id)
          .collection('SchoolAttendance')
          .snapshots()
          .listen((event) async {
        if (event.docChanges.isNotEmpty) {
          event.docChanges.forEach((element) 
          {
            if (element.type == DocumentChangeType.added) {
            print('sendAttendanceNotification1');
            int notify_id = random.nextInt(pow(2, 31).toInt() - 1);

            SchoolAttendanceModel attendanceStatus =
                SchoolAttendanceModel.fromJson(element.doc.data()!);

            String notifyBody =
                '${attendanceStatus.action[0].toUpperCase()}${attendanceStatus.action.substring(1)} at ${DateFormat('hh:mm a').format(attendanceStatus.date)}';
            db
                .collection('Countries')
                .doc(st['country'])
                .collection('Schools')
                .doc(st['school'])
                .collection('Students')
                .doc(st.id)
                .get()
                .then((value) async {
              print('sendAttendanceNotification2');
              await flutterLocalNotificationsPlugin.show(
                  notify_id,
                  '${value['name'].split(' ')[0]} ${attendanceStatus.action[0].toUpperCase()}${attendanceStatus.action.substring(1)}',
                  notifyBody,
                  notify);
            }).catchError((error) {
              print(error.toString());
            });
          }
          });
          
        }
      });
    }
  }
}
