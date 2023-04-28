import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stguard/layout/canteen/canteen_home_screen.dart';
import 'package:stguard/layout/parent/parent_home_screen.dart';
import 'package:stguard/layout/teacher/teacher_home_screen.dart';

Map<String, Widget> homeScreens = {
  'parent': ParentHomeScreen(),
  'teacher': const TeacherHomeScreen(),
  'canteen worker': const CanteenHomeScreen()
};

String? userID;
String? userRole;

//StreamSubscription<QuerySnapshot<Object?>>? trans_listener;
Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
    transListeners = {};
Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
    attendListeners = {};

var fcmProjectToken =
    'key=AAAArAAgmhg:APA91bFj5XE1LoBN9ZdzthL9rh77pFIDSfeSlv7xEiAkBpuMNymcLh4RkFNOdOoid9EYClLMdTRKCFIqOKZlnzKxIoVfBX4UBGrsf94Su0K0qQd8xkapt7xvzohfX6B0VO8c4K54rAOV';
