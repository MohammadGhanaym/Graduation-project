import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/layout/teacher/teacher_home_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/Themes.dart';

class AddTeacherScreen extends StatelessWidget {
  AddTeacherScreen({super.key});
  TextEditingController teacherController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Community'),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is AddTeacherSucessState) {
            ShowToast(message: 'Success', state: ToastStates.SUCCESS);
            navigateAndFinish(context, TeacherHomeScreen());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                  alignment: AlignmentDirectional.center,
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Theme.of(context).primaryColor),
                  child: const Image(
                    image: AssetImage('assets/images/teacher.png'),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
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
                      const SizedBox(
                        height: 40,
                      ),
                      state is AddTeacherLoadingState
                          ? LoadingOnWaiting(
                              color: defaultColor.withOpacity(0.8),
                            )
                          : DefaultButton(
                              text: 'CONFIRM',
                              color: defaultColor.withOpacity(0.8),
                              onPressed: () {
                                TeacherCubit.get(context)
                                    .addTeacher(teacherController.text);
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
