import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/shared/components/components.dart';

class MemberSettingsScreen extends StatelessWidget {
  studentModel? student;
  MemberSettingsScreen({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
    print(student!.location!['latitude'].runtimeType);
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("${student!.name!.split(' ')[0]}'s settings"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          Text(
                            'Last Seen',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${student!.location!['time']}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 190,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () => ParentCubit.get(context).openMap(
                              lat: student!.location!['latitude'],
                              long: student!.location!['longtitude']),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                  width: 20,
                                  height: 20,
                                  image: AssetImage('assets/images/map.png')),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Find ${student!.name!.split(' ')[0]}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  )
                ],
              ),
            ));
      },
    );
  }
}
