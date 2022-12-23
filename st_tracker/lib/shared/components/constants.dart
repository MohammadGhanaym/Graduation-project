import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

String? userID;
String? userRole;
List<String>? studentIDs;
String? studentID;

StreamSubscription<QuerySnapshot<Object?>>? trans_listener;
