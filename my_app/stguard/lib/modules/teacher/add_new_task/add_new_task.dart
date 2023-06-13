import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/teacher/add_attendance/add_attendance_screen.dart';
import 'package:stguard/modules/teacher/add_note/add_note_screen.dart';
import 'package:stguard/modules/teacher/class_records/class_records_screen.dart';
import 'package:stguard/modules/teacher/get_grade_template/get_grade_template.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class AddNewTaskScreen extends StatelessWidget {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical:10.0),
        child: BlocConsumer<TeacherCubit, TeacherStates>(
          listener: (context, state) {
            
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
              children: [
                 const Padding(
                  padding: EdgeInsets.symmetric(horizontal:20.0),
                  child: Image(
                   height: 200,
                   image: AssetImage('assets/images/Classroom-amico.png')),
                ),
                const SizedBox(height: 20,),
                DefaultButton3(
                    width: double.infinity,
                    height: 100,
                    image: 'assets/images/grade.png',
                    text: 'Share Grades',
                    imageWidth: 60,
                    imageHeight: 60,
                    sizedboxWidth: 10,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    onPressed: () {
                      TeacherCubit.get(context).resetSelection();
                      navigateTo(context, GetTemplateScreen());
                    }),
                    const SizedBox(height: 5,), 
                    DefaultButton3(
                width: double.infinity,
                height: 100,
                image: 'assets/images/attendance_black.png',
                text: 'Record Attendance',
                imageWidth: 60,
                imageHeight: 60,
                sizedboxWidth: 10,
                textStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                onPressed: () {
                  TeacherCubit.get(context).resetSelection();
                  navigateTo(context, AddAttendanceScreen());
                }),
                    const SizedBox(height: 5,), 
                    DefaultButton3(
                width: double.infinity,
                height: 100,
                text: 'Share Notes',
                textStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                image: 'assets/images/reminder.png',
                imageHeight: 60,
                imageWidth: 60,
                sizedboxWidth: 10,
                onPressed: () {
                  TeacherCubit.get(context).resetSelection();
                  navigateTo(context, AddNoteScreen());
                }),
                     const SizedBox(height: 5,), 
                             DefaultButton3(
                width: double.infinity,
                height: 100,
                text: 'Records and Notes',
                textStyle: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                image: 'assets/images/class_records.png',
                imageHeight: 60,
                imageWidth: 60,
                sizedboxWidth: 10,
                onPressed: () {
                  TeacherCubit.get(context).resetSelection();
                  navigateTo(context, const ClassRecordsScreen());
                }),
                      
              ],
                          ),
            );
        
          },
         ),
      ),
    );
  }
}
