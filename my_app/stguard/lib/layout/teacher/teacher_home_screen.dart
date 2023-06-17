import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/states.dart';
import 'package:stguard/modules/login/login_screen.dart';
import 'package:stguard/modules/teacher/add_new_task/add_new_task.dart';
import 'package:stguard/modules/teacher/join_community/join_community_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/internet_cubit/cubit.dart';
import 'package:stguard/shared/styles/themes.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TeacherCubit.get(context)
      .getTeacherPath();
    return BlocListener<InternetCubit, ConnectionStatus>(
      listener: (context, state) {
        if (state == ConnectionStatus.disconnected) {
          showSnackBar(context,
              message: 'You are currently offline.', icon: Icons.wifi_off);
        } else if (state == ConnectionStatus.connected) {
          showSnackBar(context,
              message: 'Your internet connection has been restored.',
              icon: Icons.wifi);
        }
      },
      child: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is UserSignOutSuccessState) {
            navigateAndFinish(context, LoginScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
              ),
              drawer: Drawer(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Expanded(
                      flex: 1,
                      child: DrawerHeader(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: TeacherCubit.get(context).teacher != null
                            ? UserInfo(
                                userModel: TeacherCubit.get(context).teacher!,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Settings',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(color: defaultColor)),
                            const SizedBox(
                              height: 20,
                            ),
                            DrawerItem(
                              text: 'Reset ID',
                              ontap: () => TeacherCubit.get(context).resetId(),
                              icon: const Image(
                                  color: defaultColor,
                                  image: AssetImage('assets/images/undo.png'),
                                  width: 30,
                                  height: 30),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            
                            DrawerItem(
                              text: 'Sign Out',
                              icon: const Image(
                                  color: defaultColor,
                                  image:
                                      AssetImage('assets/images/signout.png'),
                                  width: 30,
                                  height: 30),
                              ontap: () {
                                showDefaultDialog(
                                  context,
                                  title: 'Are you sure?',
                                  content: const Text(
                                    'Are you sure you want to log out?',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  buttonText1: "NEVERMIND",
                                  onPressed1: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttonText2: "SIGN OUT",
                                  onPressed2: () {
                                    TeacherCubit.get(context).signOut();
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])),
             
              body: TeacherCubit.get(context).teacherPathLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : TeacherCubit.get(context).teacherPath == null
                      ? JoinCommunityScreen(
                          image:
                              'assets/images/teacher-and-open-class-door.png')
                      : AddNewTaskScreen());
        },
      ),
    );
  }
}
