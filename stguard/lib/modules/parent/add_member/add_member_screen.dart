import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AddMember extends StatelessWidget {
  AddMember({super.key});
  var idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {
        if (state is AddFamilyMemberSuccess) {
          ShowToast(
              message: 'Member is added successfully',
              state: ToastStates.SUCCESS);
          navigateAndFinish(context, ParentHomeScreen());
        } else if (state is FamilyMemberAlreadyExisted) {
          ShowToast(message: state.message!, state: ToastStates.WARNING);
        } else if (state is IDNotFound) {
          ShowToast(message: state.message!, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Find your family member',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          DefaultFormField(
                              controller: idController,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) return 'Enter student ID';
                                return null;
                              },
                              onSubmit: (p0) async =>
                                  await ParentCubit.get(context)
                                      .addFamilyMember(p0),
                              label: 'Student ID'),
                          SizedBox(
                            height: 20,
                          ),
                          state is! AddFamilyMemberLoading
                              ? DefaultButton(
                                  text: 'Confirm',
                                  height: screen_height * 0.07,
                                  color: defaultColor.withOpacity(0.8),
                                  onPressed: () async {
                                    await ParentCubit.get(context)
                                        .addFamilyMember(idController.text);
                                  },
                                )
                              : LoadingOnWaiting(
                                  height: screen_height * 0.07,
                                  color: defaultColor.withOpacity(0.8),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/add_member.png'),
                                    fit: BoxFit.contain)),
                          )
                        ])),
              ),
            ),
          ),
        );
      },
    );
  }
}
