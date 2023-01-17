import 'package:flutter/material.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/modules/parent/recharge/recharge_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class RechargeSuccessScreen extends StatelessWidget {
  var amount;
  RechargeSuccessScreen({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Processing Transaction',
                style: TextStyle(
                    fontSize: screen_width * 0.05, fontWeight: FontWeight.w700),
              ),
              Divider(),
              
              SizedBox(
                height: screen_height * 0.1,
              ),
              Image(
                image: AssetImage('assets/images/check-mark.png'),
                width: 100,
                height: 100,
                color: defaultColor,
              ),
              Text(
                'Success!',
                style: TextStyle(
                    color: defaultColor,
                    fontSize: screen_width * 0.1,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: screen_height * 0.05,
              ),
              Text('Your transaction has been processed',
                  style: TextStyle(
                      fontSize: screen_width * 0.04,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: screen_height * 0.1,
              ),
              Text(amount,
                  style: TextStyle(
                      fontSize: screen_width * 0.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              Text('EGP',
                  style: TextStyle(
                      fontSize: screen_width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              SizedBox(
                height: screen_height * 0.1,
              ),
              DefaultButton(
                text: 'Okay',
                onPressed: () => navigateTo(context, ParentHomeScreen()),
              )
            ],
          ),
        ),
      )),
    );
  }
}
