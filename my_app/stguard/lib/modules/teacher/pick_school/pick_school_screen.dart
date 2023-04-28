import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/teacher/add_teacher/add_teacher_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/Themes.dart';

class TeacherPickSchoolScreen extends StatelessWidget {
  const TeacherPickSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is PickSchoolState) {
            navigateTo(context, AddTeacherScreen());
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListView.separated(
                itemBuilder: (context, index) => SchoolItem(
                      school: TeacherCubit.get(context).schools[index],
                      onTap: () => TeacherCubit.get(context)
                          .pickSchool(TeacherCubit.get(context).schools[index]),
                    ),
                separatorBuilder: (context, index) => Divider(
                      color: defaultColor.withOpacity(0.8),
                    ),
                itemCount: TeacherCubit.get(context).schools.length),
          );
        },
      ),
    );
  }
}
