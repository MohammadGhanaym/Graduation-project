import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/models/student_attendance.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  LessonModel lesson;
  AttendanceDetailsScreen({required this.lesson, super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        TeacherCubit.get(context).getLessonAttendance(lesson.name);
        return BlocConsumer<TeacherCubit, TeacherStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                
              ),
              body: Padding(
                padding: EdgeInsets.all(screen_width * 0.05),
                child: ConditionalBuilder(
                  condition: state is! GetLessonAttendanceLoadingState,
                  builder: (context) => SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Card(
                            child: Padding(
                              padding:  EdgeInsets.all(screen_width*0.03),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${lesson.name.substring(0, 1).toUpperCase()}${lesson.name.substring(1)}',
                                    style: TextStyle(
                                      fontSize: screen_width * 0.05,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: screen_height * 0.02,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        lesson.grade,
                                        style: TextStyle(
                                            fontSize: screen_width * 0.05,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: screen_width * 0.25,
                                      ),
                                      Text(
                                          getDate(lesson.datetime,
                                              format: 'yyyy-MM-dd HH:mm:ss'),
                                          style: TextStyle(
                                              fontSize: screen_width * 0.05,
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                  SizedBox(
                                    height: screen_height * 0.02,
                                  ),
                                  Center(
                                    child: InkWell(
                                        child: Image(
                                            width: screen_width * 0.1,
                                            height: screen_height * 0.07,
                                            image:
                                                AssetImage('assets/images/excel.png')),
                                        onTap: () async {
                                          if (await Permission.storage.isDenied) {
                                            print(Permission.storage.isDenied);
                                            await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Storage Permission"),
                                                content: Text(
                                                    "This app requires storage permission to save files."),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text("Open settings"),
                                                    onPressed: () async {
                                                      // Open the app settings to let the user grant the permission
                                                      openAppSettings();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text("Save to"),
                                                  content: const Text(
                                                      "Choose a location to save the file"),
                                                  actions: [
                                                    DefaultButton(
                                                      text: "Documents",
                                                      color:
                                                          defaultColor.withOpacity(0.8),
                                                      onPressed: () async {
                                                        // Save the file to the documents directory
                          
                                                        String filePath =
                                                            "/storage/emulated/0/Documents";
                                                        // Write the file
                                                        TeacherCubit.get(context)
                                                            .saveAttendanceToExcel(
                                                                lesson,
                                                                filePath,
                                                                TeacherCubit.get(context)
                                                                    .lessonAttendance);
                          
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: screen_height * 0.02,
                                                    ),
                                                    DefaultButton(
                                                      text: "Downloads",
                                                      color:
                                                          defaultColor.withOpacity(0.8),
                                                      onPressed: () {
                                                        // Save the file to the downloads directory
                                                        String filePath =
                                                            "/storage/emulated/0/Download";
                                                        // Write the file
                                                        TeacherCubit.get(context)
                                                            .saveAttendanceToExcel(
                                                                lesson,
                                                                filePath,
                                                                TeacherCubit.get(context)
                                                                    .lessonAttendance);
                          
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screen_height * 0.02,
                        ),Divider(
                          color: defaultColor,
                          thickness: 2,
                        ),
                        ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
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
                        Divider(
                          color: defaultColor.withOpacity(0.8),
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  fallback: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
