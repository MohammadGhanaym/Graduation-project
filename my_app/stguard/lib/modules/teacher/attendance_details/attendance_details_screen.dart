import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/models/student_attendance.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';
import 'package:stguard/shared/styles/themes.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  LessonAttendance lessonAttendance;
  AttendanceDetailsScreen({required this.lessonAttendance, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title:  Text('Attendance Details',style: Theme.of(context).textTheme.titleLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: BlocConsumer<TeacherCubit, TeacherStates>(
            listener: (context, state) {
              if (state is SavetoExcelSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Saved successfully to Excel file",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            builder: (context, state) {
              return ConditionalBuilder(
                condition: state is! GetLessonAttendanceLoadingState,
                builder: (context) => SingleChildScrollView(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                          
                          decoration: const BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadiusDirectional.only(bottomEnd: Radius.circular(20), bottomStart: Radius.circular(20))),
                          child:  Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lessonAttendance.lessonName.substring(0, 1).toUpperCase()}${lessonAttendance.lessonName.substring(1)}',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    TeacherCubit.get(context).selectedClassName!,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold, color: Colors.white),
                                  ),Spacer(),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      getDate(lessonAttendance.datetime,
                                          format: 'd MMM yy, hh:mm a'),
                                          overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        fontWeight: FontWeight.bold, color: Colors.white))
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              
                              Center(
                                child: InkWell(
                                    child: const Card(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Image(
                                            width: 40,
                                            height: 40,
                                            image: AssetImage(
                                                'assets/images/excel.png')),
                                      ),
                                    ),
                                    onTap: () async {
                                    
                                        TeacherCubit.get(context)
                                            .getSelectedFolder()
                                            .then((path) {
                                          if (path != null) {
                                            TeacherCubit.get(context)
                                                .saveAttendanceToExcel(filePath:
                                                    path,
                                                    lessonAttendance: lessonAttendance);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Save to"),
                                                  content: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          "Choose a location to save the file"),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: TextButton(
                                                              child: const Text(
                                                                  "Documents"),
                                                              onPressed:
                                                                  () async {
                                                                // Save the file to the documents directory
                                                                String
                                                                    filePath =
                                                                    "/storage/emulated/0/Documents";
                                                                // Write the file
                                                                TeacherCubit.get(
                                                                        context)
                                                                    .saveAttendanceToExcel(
                                                                        filePath:filePath,
                                                                        lessonAttendance:lessonAttendance);

                                                                if (TeacherCubit
                                                                        .get(
                                                                            context)
                                                                    .saveToThisLocation) {
                                                                  // Save the file path to the shared preferences
                                                                  CacheHelper.saveData(
                                                                      key:
                                                                          'selected_folder',
                                                                      value:
                                                                          filePath);
                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 20),
                                                          Expanded(
                                                            child: TextButton(
                                                              child: const Text(
                                                                  "Download"),
                                                              onPressed: () {
                                                                // Save the file to the downloads directory
                                                                String
                                                                    filePath =
                                                                    "/storage/emulated/0/Download";
                                                                // Write the file
                                                                TeacherCubit.get(
                                                                        context)
                                                                    .saveAttendanceToExcel(
                                                                       filePath: filePath,lessonAttendance:
                                                                        lessonAttendance);

                                                                if (TeacherCubit
                                                                        .get(
                                                                            context)
                                                                    .saveToThisLocation) {
                                                                  // Save the file path to the shared preferences
                                                                  CacheHelper.saveData(
                                                                      key:
                                                                          'selected_folder',
                                                                      value:
                                                                          filePath);
                                                                }

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          BlocBuilder<
                                                              TeacherCubit,
                                                              TeacherStates>(
                                                            builder: (context,
                                                                    state) =>
                                                                Checkbox(
                                                              value: TeacherCubit
                                                                      .get(
                                                                          context)
                                                                  .saveToThisLocation,
                                                              onChanged:
                                                                  (value) {
                                                                TeacherCubit.get(
                                                                        context)
                                                                    .saveSelectedFolder(
                                                                        value);
                                                              },
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            child: Text(
                                                                "Always save to this location"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        });
                                      
                                    }),
                              ),
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
                            itemBuilder: (context, index) =>
                                AttendanceDetailsCard(
                                  student: TeacherCubit.get(context)
                                .students[index],
                                    lessonAttendance : lessonAttendance),
                            separatorBuilder: (context, index) => const Divider(
                                  thickness: 1,
                                ),
                            itemCount: TeacherCubit.get(context)
                                .students
                                .length),
                      ],
                    ),
                  ),
                ),
                fallback: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
