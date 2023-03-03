import 'package:flutter/material.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class RechargeSuccessScreen extends StatelessWidget {
  RechargeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Divider(),
              SizedBox(
                height: 80,
              ),
              Image(
                image: AssetImage('assets/images/check-mark.png'),
                width: 100,
                height: 100,
                color: defaultColor,
              ),
              SizedBox(height:10),
              Text(
                'Success!',
                style: TextStyle(
                    color: defaultColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Your transaction has been processed',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height:80,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('500',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                          SizedBox(width: 5,),
                  Text('EGP',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                ],
              ),
              SizedBox(
                height:180,
              ),
              DefaultButton(
                text: 'Okay',
                color: defaultColor.withOpacity(0.8),
                onPressed: () => navigateTo(context, ParentHomeScreen()),
              )
            ],
          ),
        ),
      )),
    );
  }
}
