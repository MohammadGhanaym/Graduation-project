import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/layout/teacher/teacher_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AddTeacherScreen extends StatelessWidget {
  AddTeacherScreen({super.key});
  TextEditingController teacherController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Community'),
        centerTitle: true,
      ),
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is GetTeacherPathSuccessState) {
            navigateAndFinish(context, TeacherHomeScreen());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screen_height * 0.05,
                  horizontal: screen_width * 0.1),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/teacher.png'),
                    color: defaultColor,
                  ),
                  SizedBox(
                    height: screen_height * 0.05,
                  ),
                  DefaultFormField(
                      controller: teacherController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'ID must not be empty';
                        }
                        return null;
                      },
                      label: 'Teacher ID'),
                  SizedBox(
                    height: screen_height * 0.05,
                  ),
                  DefaultButton(
                    text: 'CONFIRM',
                    color: defaultColor.withOpacity(0.8),
                    onPressed: () {
                      TeacherCubit.get(context)
                          .addTeacher(teacherController.text);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
