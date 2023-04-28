import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/teacher/take_attendance/take_attendance_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/Themes.dart';

class AddAttendanceScreen extends StatelessWidget {
  AddAttendanceScreen({super.key});
  var lessonController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is GetStudentNamesSuccess) {
            navigateTo(context, TakeAttendanceScreen());
          } else if (state is GetStudentNamesError) {
            ShowToast(message: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: SizedBox(
                  height: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
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
                              image: AssetImage(
                                  'assets/images/attendance_black.png')),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: DefaultFormField(
                              controller: lessonController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Lesson name must not be empty';
                                }
                                if (TeacherCubit.get(context)
                                    .lessons
                                    .isNotEmpty) {
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
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Class Name',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: Colors.black54)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                width: 300,
                                height: 40,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => GradeItem(
                                        grade: TeacherCubit.get(context)
                                            .grades[index]),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(width: 10),
                                    itemCount: TeacherCubit.get(context)
                                        .grades
                                        .length),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0),
                        child: DefaultButton(
                          text: 'Add',
                          showCircularProgressIndicator: state is GetStudentNamesLoading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              TeacherCubit.get(context)
                                  .setLessonName(lessonController.text);
                              TeacherCubit.get(context)
                                  .getStudentsNames();
                              lessonController.clear();
                            }
                          },
                          color: defaultColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
