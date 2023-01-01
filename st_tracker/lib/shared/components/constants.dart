import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

String? userID;
String? userRole;

//String? studentID;
int? count = 0;
//StreamSubscription<QuerySnapshot<Object?>>? trans_listener;
Map<String, dynamic> transListeners = {};
Map<String, dynamic> attendListeners = {};

var random =
    Random(); // keep this somewhere in a static variable. Just make sure to initialize only once.

var fcmToken;

var fcm_project_token =
    'key=AAAArAAgmhg:APA91bFj5XE1LoBN9ZdzthL9rh77pFIDSfeSlv7xEiAkBpuMNymcLh4RkFNOdOoid9EYClLMdTRKCFIqOKZlnzKxIoVfBX4UBGrsf94Su0K0qQd8xkapt7xvzohfX6B0VO8c4K54rAOV';

var background_service;

var screen_height;
var screen_width;
