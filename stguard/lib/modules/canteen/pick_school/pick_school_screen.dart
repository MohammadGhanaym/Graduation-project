import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/add_canteen_worker/add_canteen_screen.dart';
import 'package:st_tracker/shared/components/components.dart';


class CanteenPickSchoolScreen extends StatelessWidget {
  const CanteenPickSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {
          if (state is PickSchoolState) {
            navigateTo(context, AddCanteenScreen());
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (context, index) => SchoolItem(
                            school: CanteenCubit.get(context).schools[index],
                            onTap: () => CanteenCubit.get(context)
                                .pickSchool(CanteenCubit.get(context).schools[index]),
                          ),
                      separatorBuilder: (context, index) => const Divider(
                            color: Colors.grey,
                          ),
                      itemCount: CanteenCubit.get(context).schools.length),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
