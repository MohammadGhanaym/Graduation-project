import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/modules/parent/attendance/attendance_screen.dart';
import 'package:stguard/modules/parent/notes_list/notes_list.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class ClassUpdatesScreen extends StatelessWidget {
  StudentModel student;
  ClassUpdatesScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Image(image: AssetImage('assets/images/class_updates_img.png'),),
              SizedBox(height: 20,),
              InkWell(
                onTap: () => navigateTo(context, const NotesListsScreen()),
                child: SettingsCard(
                  elevation: 1.0,
                    condition: state is! GetNotesLoadingState,
                    children: [
                      SizedBox(
                        height: 55,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const ImageIcon(
                                AssetImage('assets/images/notepad.png'),
                                size: 30,
                                color: defaultColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Class Notes',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: defaultColor,
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (ParentCubit.get(context).notes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                          child: Row(
                            children: [
                              Text(
                                'Recent',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              Text(
                                ParentCubit.get(context).notes[0].title,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 15),
                              )
                            ],
                          ),
                        )
                    ]),
              ),
              SizedBox(height: 10,),
                 InkWell(
                onTap: () => navigateTo(context,  ClassAttendanceScreen(st: student)),
                child: SettingsCard(
                  elevation: 1.0,
                    condition: state is! GetAttendanceLoadingState,
                    children: [
                      SizedBox(
                        height: 55,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const ImageIcon(
                                AssetImage('assets/images/class_attendance.png'),
                                size: 30,
                                color: defaultColor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Class Attendance',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: defaultColor,
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (ParentCubit.get(context).studentAttendance!=null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                          child: Row(
                            children: [
                              Text(
                                'Recent',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const Spacer(),
                              Text(
                                ParentCubit.get(context).studentAttendance![0].lessonName,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 15),
                              )
                            ],
                          ),
                        )
                    ]),
              ),
            
            ],
          ),
        ),
      )
    ;
      },
       );
  }
}
