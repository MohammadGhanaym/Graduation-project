import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class ClassRecordsScreen extends StatelessWidget {
  const ClassRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                color: defaultColor,
              ),
              elevation: 0.0,
              title: Text(
                'Class Records and Notes',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: defaultColor),
              ),
              bottom: PreferredSize(
                  preferredSize: const Size(double.infinity, 30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        PopupMenuButton(
                          itemBuilder: (context) => List.generate(
                              TeacherCubit.get(context).classes.length,
                              (index) => PopupMenuItem(
                                  value:
                                      TeacherCubit.get(context).classes[index],
                                  child: Text(
                                    TeacherCubit.get(context).classes[index],
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ))),
                          onSelected: (className) async {
                            await TeacherCubit.get(context)
                                .filterNotesByClass(className);
                            await TeacherCubit.get(context)
                                .filterAttendanceByClass(className);

                            await TeacherCubit.get(context)
                                .filterExamResultsByClass(className);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.arrow_drop_down,
                                color: defaultColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                TeacherCubit.get(context).selectedClassName ??
                                    'Select a Class',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: defaultColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              showDefaultDialog(
                                context,
                                content: const Image(image: 
                                AssetImage('assets/images/Date picker-rafiki.png')),
                                title: "Select Date",
                                buttonText1: 'All Time',
                                onPressed1: () {
                                  TeacherCubit.get(context).changeAllTime(true);
                                  Navigator.pop(context);
                                },
                                buttonText2: 'By Date',
                                onPressed2: () {
                                  Navigator.pop(context);
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now())
                                      .then((value) {
                                    TeacherCubit.get(context)
                                        .updateDate(date: value);
                                  });
                                  
                                },
                              );
                            },
                            child: Text(
                              TeacherCubit.get(context).allTime?'All':
                              checkToday(
                                      TeacherCubit.get(context).filterByDate) ??
                                  getDate(
                                      TeacherCubit.get(context).filterByDate,
                                      format: 'dd/MM/yyyy'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: defaultColor),
                            )),
                      ],
                    ),
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    const SliverToBoxAdapter(
                      child: TabBar(labelColor: defaultColor, tabs: [
                        Tab(
                          icon: ImageIcon(AssetImage('assets/images/notepad.png')),
                          text: 'Notes',
                        ),
                        Tab(
                          icon:
                              ImageIcon(AssetImage('assets/images/grades.png')),
                          text: 'Grades',
                        ),
                        Tab(
                          icon: ImageIcon(AssetImage(
                              'assets/images/attendance_history.png')),
                          text: 'Attendance',
                        )
                      ]),
                    )
                  ];
                },
                body: TabBarView(children: [
                  NoteList(
                      loadingCondition: state is GetNotesByClassLoadingState),
                  GradesList(loadingCondition: state is GetGradesLoadingState),
                  AttendanceList(
                    loadingCondition: state is GetLessonAttendanceLoadingState,
                  )
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
