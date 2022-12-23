import 'package:flutter/material.dart';
import 'package:st_tracker/shared/components/components.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          Text('Teacher Home'),
          TextButton(
              onPressed: () {
                signOut(context);
              },
              child: Text('Sign Out'))
        ],
      )),
    );
  }
}
