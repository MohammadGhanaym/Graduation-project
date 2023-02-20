import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  ActivityModel model;
  AttendanceHistoryScreen({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    ParentCubit.get(context).getAttendanceHistory(model.st_id);
    return Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<ParentCubit, ParentStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: screen_height * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screen_width * 0.4,
                      ),
                      Text(
                        'Time',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: screen_width * 0.1),
                      Text(
                        'Movement',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: screen_height * 0.7,
                    width: screen_width,
                    child: ListView.separated(
                        itemBuilder: (context, index) => AttendanceHistoryItem(
                            model: ParentCubit.get(context)
                                .attendance_history[index]),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: screen_height * 0.01),
                        itemCount:
                            ParentCubit.get(context).attendance_history.length),
                  )
                ],
              ),
            );
          },
        ));
  }
}
