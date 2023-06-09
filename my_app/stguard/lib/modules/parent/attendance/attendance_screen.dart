import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/shared/components/components.dart';

class ClassAttendanceScreen extends StatelessWidget {
  StudentModel st;
 ClassAttendanceScreen({super.key, required this.st});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Class Attendance',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: ConditionalBuilder(
            condition: ParentCubit.get(context).studentAttendance != null,
            builder: (context) => ConditionalBuilder(
              condition: ParentCubit.get(context).studentAttendance!.isNotEmpty,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ParentAttendanceItem(
                        st:st,
                            attendanceDetails: ParentCubit.get(context)
                                .studentAttendance![index],
                          ),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount:
                          ParentCubit.get(context).studentAttendance!.length),
                ),
              ),
              fallback: (context) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                        'No Attendance Recorded',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      'No Attendance Recorded',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
