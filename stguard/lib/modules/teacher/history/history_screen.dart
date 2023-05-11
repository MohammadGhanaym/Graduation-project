import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/teacher/attendance_details/attendance_details_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is DeleteLessonAttendanceSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ConditionalBuilder(
            condition: TeacherCubit.get(context).lessons.isNotEmpty,
            builder: (context) => SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => LessonCard(
                        lesson: TeacherCubit.get(context).lessons[index],
                        onTap: () {
                          navigateTo(
                              context,
                              AttendanceDetailsScreen(
                                  lesson:
                                      TeacherCubit.get(context).lessons[index]));
                        }),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: TeacherCubit.get(context).lessons.length),
              ),
            ),fallback: (context) =>  Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(image: const AssetImage('assets/images/no_attendance.png',
                    ), height: 200,color: defaultColor.withOpacity(0.3),),
                      const SizedBox(height: 5,),
                        const Text(
                          'No attendance has been taken yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }
}
