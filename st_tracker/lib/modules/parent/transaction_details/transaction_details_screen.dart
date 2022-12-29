import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/models/transactions_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  ActivityModel trans;
  TransactionDetailsScreen({required this.trans, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('TransactionDetailsScreen')),
    );
  }
}
