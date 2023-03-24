import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/modules/parent/add_member/add_member_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/themes.dart';

class PickSchoolScreen extends StatelessWidget {
  const PickSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {
          if (state is PickSchoolState) {
            navigateTo(context, AddMember());
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10),
            child: ListView.separated(
                itemBuilder: (context, index) => SchoolItem(
                      school: ParentCubit.get(context).schools[index],
                      onTap: () => ParentCubit.get(context)
                          .pickSchool(ParentCubit.get(context).schools[index]),
                    ),
                separatorBuilder: (context, index) => Divider(
                      color: defaultColor.withOpacity(0.8),
                    ),
                itemCount: ParentCubit.get(context).schools.length),
          );
        },
      ),
    );
  }
}
