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
        appBar: AppBar(
          title: const Text(
            'Attendance History',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ParentCubit, ParentStates>(
          builder: (context, state) {
            return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      SizedBox(
                        width: 150,
                      ),
                      Text(
                        'Time',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 35),
                      Text(
                        'Movement',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => AttendanceHistoryItem(
                            model: ParentCubit.get(context)
                                .attendance_history[index]),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount:
                            ParentCubit.get(context).attendance_history.length),
                  )
                ],
              ),
            ),
          )
        ;
          },
          ));
  }
}
