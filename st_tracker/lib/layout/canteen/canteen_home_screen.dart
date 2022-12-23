import 'package:flutter/material.dart';
import 'package:st_tracker/shared/components/components.dart';

class CanteenHomeScreen extends StatelessWidget {
  const CanteenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          Text('Canteen Home'),
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
