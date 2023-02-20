import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/modules/teacher/attendance_details/attendance_details_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screen_width * 0.05,
                  vertical: screen_height * 0.01),
              child: ConditionalBuilder(
                condition: TeacherCubit.get(context).lessons.isNotEmpty,
                builder: (context) => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => LessonCard(
                        width: screen_width,
                        height: screen_height,
                        lesson: TeacherCubit.get(context).lessons[index],
                        onTap: () {
                          navigateTo(
                              context,
                              AttendanceDetailsScreen(
                                  lesson:
                                      TeacherCubit.get(context).lessons[index]));
                        }),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: screen_height * 0.01),
                    itemCount: TeacherCubit.get(context).lessons.length),
                fallback: (context) => Center(
                  child: Text('No attendance has been taken yet',
                   style: TextStyle(fontSize: screen_width*0.05, fontWeight: FontWeight.w500, color: Colors.grey),),
                ),
              ),
            )),
          ),
        );
      },
    );
  }
}
