import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:st_tracker/modules/parent/cash/cash_screen.dart';
import 'package:st_tracker/modules/parent/credit_card/credit_card_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class RechargeScreen extends StatelessWidget {
  const RechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recharge'),
        titleSpacing: screen_width * 0.25,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: ImageIcon(AssetImage('assets/images/x.png'), size: 20,color: defaultColor,),
      )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'How would you like to recharge?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: screen_height * 0.05,
              ),
              
              RechargeItem(
                  leadIcon: 'assets/images/cash.png',
                  iconSize: 45,
                  text: 'Cash',
                  width: screen_width * 0.4,
                  ontap: () =>navigateTo(context, CashScreen()) ),
              SizedBox(height: screen_height*0.01,),
              RechargeItem(
                  leadIcon: 'assets/images/card.png',                iconSize: 40,

                  text: 'Add Credit Card',
                  width: screen_width * 0.15,
                  ontap: () =>navigateTo(context, CreditCardScreen()))
            ],
          ),
        ),
      ),
    );
  }
}
