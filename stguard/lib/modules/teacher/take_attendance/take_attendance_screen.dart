import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/layout/teacher/teacher_home_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class TakeAttendanceScreen extends StatelessWidget {
  TakeAttendanceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is AddNewAttendanceSuccessState) {
          TeacherCubit.get(context).switchScreen(0);
          navigateAndFinish(context, const TeacherHomeScreen());
        }
        if (state is AttendanceNotTakenState) {
          ShowToast(
              message: 'Attendance not taken yet', state: ToastStates.WARNING);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                InkWell(
                  onTap: () {
                    TeacherCubit.get(context).insertAttendance();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.save,
                    ),
                  ),
                )
              ],
            ),
            body: ConditionalBuilder(
              condition: TeacherCubit.get(context).students.isNotEmpty,
              builder:(context) =>  SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => StudentAttendanceCard(
                            student: TeacherCubit.get(context).students[index],
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 5,
                          ),
                      itemCount: TeacherCubit.get(context).students.length),
                ),
              ),
              fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                            'assets/images/student.png',
                          ),
                          height: 200,
                          color: defaultColor.withOpacity(0.3),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No Students Found!',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
            ));
      },
    );
  }
}
