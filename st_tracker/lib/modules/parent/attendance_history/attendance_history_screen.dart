import 'package:flutter/material.dart';
import 'package:st_tracker/models/activity_model.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  ActivityModel model;
  AttendanceHistoryScreen({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Attendance History')),
    );
  }
}
