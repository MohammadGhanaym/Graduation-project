import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';

class GradeSubmissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TeacherCubit.get(context).getGrades();
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Grade Submission'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Class',style: Theme.of(context).textTheme.headline5),
                  const SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: TeacherCubit.get(context).selectedClassName,
                    hint: const Text('Select a class'),
                    items: TeacherCubit.get(context)
                        .grades
                        .map((className) => DropdownMenuItem<String>(
                            value: className, child: Text(className)))
                        .toList(),
                    onChanged: (value) =>
                        TeacherCubit.get(context).selectClass(value!),
                  ),
                  const SizedBox(height: 20.0),
                  Text('Template File',style: Theme.of(context).textTheme.headline5),
                  const SizedBox(height: 10.0),
                  const Text(
                    "Don't have a template file?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 20.0),
                  DefaultButton(
                    onPressed: TeacherCubit.get(context).downloadTemplate,
                    text: 'Get Template',
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/grades_template.PNG',
                      height: 180.0,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text('Grade',style: Theme.of(context).textTheme.headline5),
                  const SizedBox(height: 10.0),
                  const Text(
                      "You have completed grading and are ready to submit. Ensure your Excel file matches the above format and submit it now.",
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DefaultButton(
                      onPressed: TeacherCubit.get(context).uploadGradesCsv,
                      text: 'Send Grades',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
