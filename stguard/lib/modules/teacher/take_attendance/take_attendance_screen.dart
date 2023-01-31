import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/layout/teacher/teacher_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class TakeAttendanceScreen extends StatelessWidget {
  TakeAttendanceScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is AddNewAttendanceSuccessState) {
          TeacherCubit.get(context).switchScreen(0);
          navigateAndFinish(context, TeacherHomeScreen());
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
                  child: Padding(
                    padding: EdgeInsets.only(right: screen_width * 0.05),
                    child: Row(children: [
                      Icon(
                        Icons.save,
                      ),
                      SizedBox(
                        width: screen_width * 0.01,
                      ),
                      Text(
                        'Save',
                        style: TextStyle(
                            fontSize: screen_width * 0.05,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screen_width * 0.05,
                    vertical: screen_height * 0.01),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => StudentAttendanceCard(
                          width: screen_width,
                          height: screen_height,
                          student: TeacherCubit.get(context).students[index],
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          height: screen_height * 0.01,
                        ),
                    itemCount: TeacherCubit.get(context).students.length),
              ),
            ));
      },
    );
  }
}
