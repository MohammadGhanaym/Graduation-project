import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/models/exam_results_model.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class UpdateGradeScreen extends StatelessWidget {
  StudentModel student;
  ExamResults examResults;
  bool showResult;
  UpdateGradeScreen(
      {super.key,
      this.showResult = true,
      required this.student,
      required this.examResults});
  TextEditingController gradeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is UpdateExamResultsSuccessState) {
          ShowToast(
              message: 'Grade updated successfully',
              state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Update Grade',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white)),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Updating ',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                            text: '${student.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "'s grade. The previous recorded grade was ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                            text:
                                '${examResults.grades.containsKey(student.id) ? examResults.grades[student.id] : 'N/A'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DefaultFormField(
                      controller: gradeController,
                      type: TextInputType.number,
                      validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Grade must not be empty';
                        } else if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }

                        return null;
                      },
                      label: 'New Grade'),
                  const SizedBox(
                    height: 20,
                  ),
                  DefaultButton(
                    showCircularProgressIndicator:
                        state is UpdateExamResultsLoadingState,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (showResult) {
                          TeacherCubit.get(context).updateStudentGrade(
                              id: student.id,
                              grade: double.parse(gradeController.text),
                              examResults: examResults);
                        } else {
                          TeacherCubit.get(context).modifyGrade(
                              grade: double.parse(gradeController.text),
                              id: student.id);
                        }
                      }
                    },
                    color: defaultColor.withOpacity(0.8),
                    text: 'Update',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
