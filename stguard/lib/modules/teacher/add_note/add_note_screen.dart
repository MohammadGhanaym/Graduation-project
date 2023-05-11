import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:multiselect/multiselect.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/layout/teacher/teacher_home_screen.dart';
import 'package:stguard/shared/components/components.dart';

class AddNoteScreen extends StatelessWidget {
 
  AddNoteScreen({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {
        if (state is NoteSendSuccessState) {
          ShowToast(
              message: 'Note sent successfully', state: ToastStates.SUCCESS);
          titleController.clear();
          contentController.clear();
          navigateAndFinish(context, const TeacherHomeScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            
            title: const Text('Send Note'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title', style: Theme.of(context).textTheme.headline5),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultFormField(
                        controller: titleController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Title must not be empty';
                          }

                          return null;
                        },
                        label: 'Title'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Content (optional)',
                        style: Theme.of(context).textTheme.headline5),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultFormField(
                        controller: contentController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.length > 2000) {
                            return 'Please note that the content size should not exceed 2000 words';
                          }
                          return null;
                        },
                        label: 'Content'),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: TeacherCubit.get(context).pickFile,
                          child: Container(
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
                        Wrap(
                          children: List.generate(
                              TeacherCubit.get(context).uploadFileInfos.length,
                              (index) => FileItem(
                                  fileName: TeacherCubit.get(context)
                                      .uploadFileInfos[index]
                                      .fileName,
                                  onPressed: () async =>
                                      await TeacherCubit.get(context)
                                          .cancelFileUpload(index),
                                  progress: TeacherCubit.get(context)
                                      .uploadFileInfos[index]
                                      .progress)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subject',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
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
                          underline: Container(
                            height: 1,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Class',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: TeacherCubit.get(context).selectedClassName,
                          onChanged: (value) {
                            TeacherCubit.get(context).selectClass(value);
                          },
                          items: TeacherCubit.get(context)
                              .classes
                              .map((className) => DropdownMenuItem<String>(
                                  value: className, child: Text(className)))
                              .toList(),
                          isExpanded: true,
                          underline: Container(
                            height: 1,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Send to all students'),
                          value: TeacherCubit.get(context).sendToAll,
                          onChanged: (value) {
                            TeacherCubit.get(context).changeSendToAll(value);
                          },
                        ),
                        if (!TeacherCubit.get(context).sendToAll)
                          ConditionalBuilder(
                            condition: state is! GetStudentNamesLoading,
                            builder: (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'Student',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                const SizedBox(height: 10),
                                ConditionalBuilder(
                                  condition: TeacherCubit.get(context)
                                      .students
                                      .isNotEmpty,
                                  builder: (context) => DropDownMultiSelect<String>(
                                    selectedValues: TeacherCubit.get(context)
                                        .selectedStudents,
                                    onChanged: TeacherCubit.get(context).getSelectedStudents,
                                    options: TeacherCubit.get(context).students.map((e) => e.name!).toList(),
                                        
                                   
                                  ),
                                  fallback: (context) =>
                                      const Text('No Students Found'),
                                ),
                              ],
                            ),
                            fallback: (context) => const Center(
                                child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DefaultButton(
                      showCircularProgressIndicator: state is NoteSendLoadingState,
                      text: 'Send',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          TeacherCubit.get(context).sendNote(
                              titleController.text, contentController.text);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
