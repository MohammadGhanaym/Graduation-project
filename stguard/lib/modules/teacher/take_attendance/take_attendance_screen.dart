import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/layout/teacher/teacher_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';

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
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20),
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
            ));
      },
    );
  }
}
