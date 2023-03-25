import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/themes.dart';

class AddMember extends StatelessWidget {
  AddMember({super.key});
  var idController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
        } else if (state is FamilyMemberAlreadyHasParent) {
          ShowToast(message: state.message!, state: ToastStates.WARNING);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Find your family member',
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/images/add_member.png'),
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Form(
                            key: formKey,
                            child: DefaultFormField(
                                controller: idController,
                                type: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter student ID';
                                  }
                                  return null;
                                },
                                onSubmit: (p0) async =>
                                    await ParentCubit.get(context)
                                        .addFamilyMember(p0),
                                label: 'Student ID'),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          state is! AddFamilyMemberLoading
                              ? DefaultButton(
                                  text: 'Confirm',
                                  height: 55,
                                  color: defaultColor.withOpacity(0.8),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await ParentCubit.get(context)
                                          .addFamilyMember(idController.text);
                                    }
                                  },
                                )
                              : LoadingOnWaiting(
                                  height: 55,
                                  color: defaultColor.withOpacity(0.8),
                                ),
                        ])),
              ),
            ),
          ),
        );
      },
    );
  }
}
