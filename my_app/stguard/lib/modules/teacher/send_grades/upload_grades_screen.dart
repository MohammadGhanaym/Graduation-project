import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/models/exam_results_model.dart';
import 'package:stguard/modules/teacher/exam_results_details/exam_results_details_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class GradeSubmissionPage extends StatelessWidget {
  GradeSubmissionPage({super.key});
  TextEditingController examController = TextEditingController();
  TextEditingController maxGradeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is GradeFileNotSelectedState) {
          ShowToast(
              message:
                  "Please choose the Excel file containing the students' grades",
              state: ToastStates.WARNING);
        }
        if (state is CheckGradeTemplateFormatState) {
          ShowToast(message: state.error, state: ToastStates.ERROR);
        }
        if (state is GradeFileValidationSuccess) {
          navigateTo(
              context,
              ExamResultsDetailsScreen(
                showResult: false,
                examResults: ExamResults(examType: examController.text, 
                maximumAchievableGrade: double.parse(maxGradeController.text),
                 subject: TeacherCubit.get(context).selectedSubject??'',
                  teacher: TeacherCubit.get(context).teacherName??'', 
                 grades: TeacherCubit.get(context).grades, 
                 datetime: DateTime.now())
     
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Grade Report',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          "You have completed grading and are ready to submit. Please ensure that your Excel file matches the grade template format and proceed with the submission",
                          style: TextStyle(fontSize: 15, color: Colors.grey)),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Exam Type',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('e.g., Quiz, Final, Midterm',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultFormField(
                          controller: examController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Exam type must not be empty';
                            }

                            return null;
                          },
                          label: 'Exam Type'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Maximum Achievable Grade',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(
                        height: 15,
                      ),
                      DefaultFormField(
                          controller: maxGradeController,
                          type: TextInputType.number,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Maximum achievable grade must not be empty';
                            } else if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }

                            return null;
                          },
                          label: 'Maximum Achievable Grade'),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: TeacherCubit.get(context).selectGradesFile,
                            child: SizedBox(
                              height: 55,
                              child: Row(
                                children: const [
                                  Icon(Icons.attach_file),
                                  SizedBox(width: 10),
                                  Text(
                                    'Attach',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ),
                          if (TeacherCubit.get(context).gradeFilePath != null)
                            FileItem(
                              fileName: TeacherCubit.get(context)
                                  .gradeFilePath!
                                  .split('/')
                                  .last,
                              onPressed: () {
                                TeacherCubit.get(context).deleteGradeFile();
                              },
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DefaultButton(
                          showCircularProgressIndicator:
                              state is UploadGradesLoadingState,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              TeacherCubit.get(context)
                                  .checkFileFormatAndUploadGrades(
                                      examType: examController.text,
                                      maximumAchievableGrade: double.parse(
                                          maxGradeController.text));
                            }
                          },
                          color: defaultColor.withOpacity(0.8),
                          text: 'Check',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
