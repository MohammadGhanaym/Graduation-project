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
          if (state is GetStudentNamesError) {
            if (TeacherCubit.get(context).students.isEmpty) {
              ShowToast(message: 'No Students Found', state: ToastStates.ERROR);
            } else {
              ShowToast(message: state.error, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DefaultFormField(
                          controller: lessonController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Lesson name must not be empty';
                            }
                          
                            
                            return null;
                          },
                          label: 'Lesson Name'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Subject',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(10),
                              hint: Text('Select a subject', style: Theme.of(context).textTheme.bodySmall,),
                              value: TeacherCubit.get(context).selectedSubject,
                              onChanged: (value) {
                                TeacherCubit.get(context).selectSubject(value);
                              },
                              items: TeacherCubit.get(context)
                                  .subjects
                                  .map((subjectName) => DropdownMenuItem<String>(
                                      value: subjectName, child: Text(subjectName)))
                                  .toList(),
                                  decoration: const InputDecoration.collapsed(
                                hintText: 'Select a subject'),
                              isExpanded: true,
                            validator: (value) {
                                        if (value == null || value.isEmpty) {
                                return 'Subject must not be empty';
                              }
                    
                              return null;
                            },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Class',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(10),
                              hint: Text('Select a class', style: Theme.of(context).textTheme.bodySmall,),
                              value: TeacherCubit.get(context).selectedClassName,
                              decoration: const InputDecoration.collapsed(
                              hintText: 'Select a class'),
                              onChanged: (value) {
                                TeacherCubit.get(context).selectClass(value);
                              },validator: (value) {
                                      if (value == null || value.isEmpty) {
                                return 'Class must not be empty';
                              }
                    
                              return null;
                              },
                              items: TeacherCubit.get(context)
                                  .classes
                                  .map((className) => DropdownMenuItem<String>(
                                      value: className, child: Text(className)))
                                  .toList(),
                              isExpanded: true,
                              
                            ),
                            const SizedBox(height: 20),
                          DefaultButton(
                            text: 'Add',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (TeacherCubit.get(context).selectedClassName !=
                                    null) {
                                      TeacherCubit.get(context)
                                    .setLessonName(lessonController.text);
                                navigateTo(context, TakeAttendanceScreen());
                                lessonController.clear();
                                } else {
                                  ShowToast(
                                      message: 'Please select a class',
                                      state: ToastStates.WARNING);
                                }
                                
                              }
                            },
                            color: defaultColor.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
