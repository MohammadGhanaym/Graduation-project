import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String? userID;
String? userRole;
List<String>? studentIDs;
String? studentID;

StreamSubscription<QuerySnapshot<Object?>>? trans_listener;
//StreamSubscription<QuerySnapshot<Object?>>? background_trans_listener;
var random =
    Random(); // keep this somewhere in a static variable. Just make sure to initialize only once.

var fcmToken;

var fcm_project_token =
    'key=AAAArAAgmhg:APA91bFj5XE1LoBN9ZdzthL9rh77pFIDSfeSlv7xEiAkBpuMNymcLh4RkFNOdOoid9EYClLMdTRKCFIqOKZlnzKxIoVfBX4UBGrsf94Su0K0qQd8xkapt7xvzohfX6B0VO8c4K54rAOV';
