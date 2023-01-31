import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/models/student_attendance.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  LessonModel lesson;
  AttendanceDetailsScreen({required this.lesson, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        TeacherCubit.get(context).getLessonAttendance(lesson.name);
        return BlocConsumer<TeacherCubit, TeacherStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text('attendance details')),
            );
          },
        );
      },
    );
  }
}
