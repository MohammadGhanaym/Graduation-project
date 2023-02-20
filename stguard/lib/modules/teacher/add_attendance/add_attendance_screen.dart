import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/modules/teacher/take_attendance/take_attendance_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AddAttendanceScreen extends StatelessWidget {
  AddAttendanceScreen({super.key});
  var lessonController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    print(screen_height);
    return Scaffold(
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is GetStudentNamesSuccess) {
            navigateTo(context, TakeAttendanceScreen());
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screen_width * 0.056,
                      vertical: screen_height * 0.025),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          width: screen_width * 0.5,
                          height: screen_width * 0.5,
                          color: defaultColor,
                          image:
                              AssetImage('assets/images/attendance_black.png')),
                      SizedBox(
                        height: screen_height * 0.02,
                      ),
                      DefaultFormField(
                          controller: lessonController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Lesson name must not be empty';
                            }
                            if (TeacherCubit.get(context).lessons.isNotEmpty) {
                              if (TeacherCubit.get(context)
                                  .lessons
                                  .map((e) => e.name)
                                  .toList()
                                  .contains(value)) {
                                return 'Lesson name already existed';
                              }
                            }
                            return null;
                          },
                          label: 'Lesson Name'),
                      SizedBox(
                        height: screen_height * 0.02,
                      ),
                      Container(
                        width: screen_width * 0.4,
                        height: screen_height * 0.3,
                        padding: EdgeInsets.symmetric(
                            vertical: screen_height * 0.02),
                        alignment: AlignmentDirectional.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(20),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Select Grade',
                              style: TextStyle(
                                  fontSize: screen_width * 0.05,
                                  color: Colors.black54),
                            ),
                            SizedBox(
                              height: screen_height * 0.01,
                            ),
                            Container(
                              alignment: AlignmentDirectional.center,
                              width: screen_width * 0.5,
                              height: screen_height * 0.2,
                              child: ListWheelScrollView(
                                  itemExtent: screen_height * 0.05,
                                  diameterRatio: 1,
                                  onSelectedItemChanged: (value) {
                                    TeacherCubit.get(context)
                                        .selectGrade(value);
                                    print(TeacherCubit.get(context)
                                        .grades[value]);
                                  },
                                  physics: const FixedExtentScrollPhysics(),
                                  children: List.generate(
                                      TeacherCubit.get(context).grades.length,
                                      (index) => Container(
                                            alignment:
                                                AlignmentDirectional.center,
                                            width: screen_width * 0.1,
                                            height: screen_height * 0.01,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: TeacherCubit.get(
                                                                    context)
                                                                .selectedGrade ==
                                                            TeacherCubit.get(
                                                                    context)
                                                                .grades[index]
                                                        ? defaultColor
                                                            .withOpacity(0.8)
                                                        : Colors.grey),
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(5)),
                                            child: Text(
                                                TeacherCubit.get(context)
                                                    .grades[index]),
                                          ))),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screen_height * 0.03,
                      ),
                      state is GetStudentNamesLoading
                          ? LoadingOnWaiting(
                              width: screen_width * 0.7,
                              height: screen_height * 0.06,
                              color: defaultColor.withOpacity(0.8),
                            )
                          : DefaultButton(
                              text: 'Add',
                              width: screen_width * 0.7,
                              height: screen_height * 0.06,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  TeacherCubit.get(context)
                                      .setLessonName(lessonController.text);
                                  TeacherCubit.get(context).getStudentsNames();
                                  lessonController.clear();
                                }
                              },
                              color: defaultColor.withOpacity(0.8),
                            )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
