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
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image(
                                  width: 25,
                                  height: 25,
                                  image: AssetImage('assets/images/map.png')),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Location',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 40,
                              ),
                              OutlinedButton(
                                onPressed: () => ParentCubit.get(context)
                                    .openMap(
                                        lat: student!.location!['latitude'],
                                        long: student!.location!['longtitude']),
                                child: Text(
                                  'Find ${student!.name!.split(' ')[0]}',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              SizedBox(
                                width: 30,
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey[500],
                  )
                ],
              ),
            ));
      },
    );
  }
}
