import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/models/student_attendance.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';
import 'package:stguard/shared/styles/themes.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  LessonModel lesson;
  AttendanceDetailsScreen({required this.lesson, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        TeacherCubit.get(context).getLessonAttendance(lesson.name);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Attendance Details'),
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lesson.name.substring(0, 1).toUpperCase()}${lesson.name.substring(1)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      lesson.grade,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      getDate(lesson.datetime,
                                          format: 'dd/MM/yyyy, HH:mm a'),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: InkWell(
                                    child: const Image(
                                        width: 40,
                                        height: 40,
                                        image: AssetImage(
                                            'assets/images/excel.png')),
                                    onTap: () async {
                                      if (await Permission.storage.isDenied) {
                                        print(Permission.storage.isDenied);
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Storage Permission"),
                                            content: const Text(
                                                "This app requires storage permission to save files."),
                                            actions: [
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child:
                                                    const Text("Open settings"),
                                                onPressed: () async {
                                                  // Open the app settings to let the user grant the permission
                                                  openAppSettings();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        TeacherCubit.get(context)
                                            .getSelectedFolder()
                                            .then((path) {
                                          if (path != null) {
                                            TeacherCubit.get(context)
                                                .saveAttendanceToExcel(
                                                    lesson,
                                                    path,
                                                    TeacherCubit.get(context)
                                                        .lessonAttendance);
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
                                                                        lesson,
                                                                        filePath,
                                                                        TeacherCubit.get(context)
                                                                            .lessonAttendance);

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
                                                                  "Downloads"),
                                                              onPressed: () {
                                                                // Save the file to the downloads directory
                                                                String
                                                                    filePath =
                                                                    "/storage/emulated/0/Download";
                                                                // Write the file
                                                                TeacherCubit.get(
                                                                        context)
                                                                    .saveAttendanceToExcel(
                                                                        lesson,
                                                                        filePath,
                                                                        TeacherCubit.get(context)
                                                                            .lessonAttendance);

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
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(
                          color: defaultColor,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  AttendanceDetailsCard(
                                      studentDetails: TeacherCubit.get(context)
                                          .lessonAttendance[index]),
                              separatorBuilder: (context, index) => Divider(
                                    color: defaultColor.withOpacity(0.8),
                                    thickness: 1,
                                  ),
                              itemCount: TeacherCubit.get(context)
                                  .lessonAttendance
                                  .length),
                        ),
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
