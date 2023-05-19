import 'package:flutter/material.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/modules/teacher/add_attendance/add_attendance_screen.dart';
import 'package:stguard/modules/teacher/add_note/add_note_screen.dart';
import 'package:stguard/shared/components/components.dart';

class AddNewTaskScreen extends StatelessWidget {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                alignment: AlignmentDirectional.center,
                height: 310,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Theme.of(context).primaryColor),
                child: const Image(
                    width: 200,
                    color: Colors.white,
                    image: AssetImage('assets/images/new-task.png')),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Row(
                children: [
                  Expanded(
                      child: DefaultButton2(
                          width: 140,
                          height: 140,
                          image: 'assets/images/attendance_black.png',
                          text: 'Attendance',
                          imageWidth: 70,
                          imageHeight: 70,
                          sizedboxHeight: 5,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          onPressed: () {
                            TeacherCubit.get(context).resetSelection();
                            navigateTo(context, AddAttendanceScreen());
                          })),
                  Expanded(
                      child: DefaultButton2(
                          width: 140,
                          height: 140,
                          text: 'Note',
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          image: 'assets/images/reminder.png',
                          imageHeight: 70,
                          imageWidth: 70,
                          sizedboxHeight: 5,
                          onPressed: () {
                            TeacherCubit.get(context).resetSelection();
                            navigateTo(context, AddNoteScreen());
                          })),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
