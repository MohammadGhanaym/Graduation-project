import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/teacher/exam_results_details/exam_results_details_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class ExamResultsListScreen extends StatelessWidget {
  const ExamResultsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            title: Text(
              'Class Grades',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
            actions: [
              PopupMenuButton(
                icon: const ImageIcon(
                    color: Colors.white,
                    AssetImage('assets/images/adjust.png')),
                itemBuilder: (context) => List.generate(
                    TeacherCubit.get(context).classes.length,
                    (index) => PopupMenuItem(
                        value: TeacherCubit.get(context).classes[index],
                        child: Text(
                          TeacherCubit.get(context).classes[index],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ))),
                onSelected: (className) {
                  TeacherCubit.get(context).filterExamResultsByClass(className);
                  
                },
              )
            ],
          ),
          body: ConditionalBuilder(
              condition: TeacherCubit.get(context).ClassExamsResults != null,
              builder: (context) => state is GetGradesLoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ConditionalBuilder(
                      condition:
                          TeacherCubit.get(context).ClassExamsResults!.isNotEmpty,
                      builder: (context) => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                TeacherCubit.get(context).ClassExamsResults!.length,
                            itemBuilder: (context, index) {
                              return DefaultClassListCard(onTap: () {
                                    navigateTo(
                                        context,
                                        ExamResultsDetailsScreen(
                                            examResults:
                                                TeacherCubit.get(context)
                                                    .ClassExamsResults![index]));
                                  },
                              teacherOnTap: () {
                                    showDefaultDialog(
                                      context,
                                      title: 'Are you sure?',
                                      content: Text(
                                        'Are you sure you want to delete these exam results?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      buttonText1: 'Cancel',
                                      onPressed1: () => Navigator.pop(context),
                                      buttonText2: 'Yes',
                                      onPressed2: () {
                                        TeacherCubit.get(context)
                                            .deleteExamResults(
                                                examResultsId: TeacherCubit.get(context)
                                                    .ClassExamsResults![index]
                                                    .id);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                               title: TeacherCubit.get(context)
                                      .ClassExamsResults![index].examType, 
                               subtitle: TeacherCubit.get(context)
                                      .ClassExamsResults![index].subject, 
                               date: TeacherCubit.get(context)
                                      .ClassExamsResults![index].datetime);
                            },
                          ),
                        ),
                      ),
                      fallback: (context) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage(
                                'assets/images/no_activity.png',
                              ),
                              height: 200,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'No Grades Available',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
              fallback: (context) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                            'assets/images/class_note.png',
                          ),
                          height: 200,
                          color: defaultColor.withOpacity(0.3),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Select a class to view its exams results',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
        );
      },
    );
  }
}
