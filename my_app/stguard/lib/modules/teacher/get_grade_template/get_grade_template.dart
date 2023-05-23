import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/teacher/send_grades/upload_grades_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class GetTemplateScreen extends StatelessWidget {
  GetTemplateScreen({super.key});
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is ClassNotSelectedState) {
          ShowToast(
              message: 'Please select a class to access its grade template.',
              state: ToastStates.WARNING);
        }
        if (state is DownloadGradeTemplateSuccessState) {
          ShowToast(
              message: 'Template saved successfully.',
              state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:  Text('Grade Report',style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Subject',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          borderRadius: BorderRadius.circular(10),
                          decoration: const InputDecoration.collapsed(
                              hintText: 'Select a subject'),
                          hint: Text(
                            'Select a subject',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Subject must not be empty';
                            }
                            return null;
                          },
                          value: TeacherCubit.get(context).selectedSubject,
                          onChanged: (value) {
                            TeacherCubit.get(context).selectSubject(value);
                          },
                          items: TeacherCubit.get(context)
                              .subjects
                              .map((subjectName) => DropdownMenuItem<String>(
                                  value: subjectName, child: Text(subjectName)))
                              .toList(),
                          isExpanded: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Class',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10.0),
                      DropdownButtonFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Class must not be empty';
                          }

                          return null;
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: 'Select a class'),
                        value: TeacherCubit.get(context).selectedClassName,
                        hint: const Text('Select a class'),
                        items: TeacherCubit.get(context)
                            .classes
                            .map((className) => DropdownMenuItem<String>(
                                value: className, child: Text(className)))
                            .toList(),
                        onChanged: (value) =>
                            TeacherCubit.get(context).selectClass(value!),
                      ),
                      const SizedBox(height: 20.0),
                      Text('Template File',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 10.0),
                      Text(
                        'Please ensure that you upload an Excel file with the format shown in the image below.',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            "Don't have a template file?",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextButton(
                              onPressed: () {
                                TeacherCubit.get(context).downloadTemplate();
                              },
                              child: Text(
                                'Click Here',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: defaultColor.withOpacity(0.8),
                                        fontWeight: FontWeight.bold),
                              ))
                        ],
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
                      Text(
                            "If you have a file in the above format with the grades filled in, please proceed to the next step",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DefaultButton(
                          color: defaultColor.withOpacity(0.8),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              navigateTo(context, GradeSubmissionPage());
                            }
                          },
                          text: 'Next',
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
