import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/layout/parent/parent_home_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/Themes.dart';

class RechargeStatusScreen extends StatelessWidget {
  String amount;
  String status;
  String statusImage;
  RechargeStatusScreen(
      {super.key,
      required this.amount,
      required this.status,
      required this.statusImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text('Processing Transaction',
              style: Theme.of(context).textTheme.headline6),
          centerTitle: true,
          elevation: 0,
          bottom: const PreferredSize(
              preferredSize: Size(double.infinity, 1), child: Divider())),
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {
 
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Image(
                    image: AssetImage('assets/images/$statusImage.png'),
                    width: 200,
                    height: 200,
                    color:
                        status == 'Success' ? defaultColor : Colors.redAccent,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    '$status!',
                    style: TextStyle(
                        color: status == 'Success'
                            ? defaultColor
                            : Colors.redAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(amount,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('EGP',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  DefaultButton(
                      text: 'Okay',
                      color: defaultColor.withOpacity(0.8),
                      onPressed: () {
                        navigateAndFinish(context, ParentHomeScreen());
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
