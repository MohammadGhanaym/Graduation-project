import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/models/exam_results_model.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class ExamResultsDetailsScreen extends StatelessWidget {
  ExamResults examResults;
  ExamResultsDetailsScreen({required this.examResults, super.key});

  @override
  Widget build(BuildContext context) {
    print(examResults.grades);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Exam Results',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: defaultColor,
                      borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(20),
                          bottomStart: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          examResults.examType,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              examResults.subject,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                            ),
                            Spacer(),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                                getDate(examResults.datetime,
                                    format: 'd MMM yy, hh:mm a'),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white))
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(child: const SizedBox(width: 240,)),
                            Text('${examResults.maximumAchievableGrade}',
                            style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),SizedBox(width: 40,)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => StudentExamResultItem(
                          student:
                              TeacherCubit.get(context).students[index],
                          grades: examResults.grades,
                        ),
                    separatorBuilder: (context, index) => const Divider(
                          thickness: 1,
                        ),
                    itemCount:
                        TeacherCubit.get(context).students.length),
              ],
            ),
          );
        },
      ),
    );
  }
}
