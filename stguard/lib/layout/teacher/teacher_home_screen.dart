import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/modules/teacher/join_community/join_community_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    requestWritePermission();
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(elevation: TeacherCubit.get(context).teacherPath==null || TeacherCubit.get(context).currentIndex==1?0:1,),
            drawer: Drawer(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      child: DrawerHeader(
                        padding: const EdgeInsets.only(left: 20, top: 40),
                        child: TeacherCubit.get(context).teacher != null
                            ? UserInfo(
                                userModel: TeacherCubit.get(context).teacher!,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
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
                          Text(
                            'Settings',
                            style: TextStyle(
                                fontSize: 25,
                                color: defaultColor.withOpacity(0.8),
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DrawerItem(
                            text: 'Reset ID',
                            ontap: () => TeacherCubit.get(context).resetId(),
                            icon: const Image(
                                image: AssetImage('assets/images/undo.png'),
                                width: 20,
                                height: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DrawerItem(
                            text: 'Sign Out',
                            icon: Image(
                                color: Colors.red.shade300,
                                image: const AssetImage(
                                    'assets/images/signout.png'),
                                width: 20,
                                height: 20),
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
                                    signOut(context);
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
                bottomNavigationBar: TeacherCubit.get(context).teacherPath == null
                ? null
                : BottomNavigationBar(
                    currentIndex: TeacherCubit.get(context).currentIndex,
                    onTap: (index) =>
                        TeacherCubit.get(context).switchScreen(index),
                    items: const [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.history), label: 'History'),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.add), label: 'New')
                      ]),
            body: TeacherCubit.get(context).teacherPath == null
                ? JoinCommunityScreen(
                    image: 'assets/images/teacher-and-open-class-door.png')
                : TeacherCubit.get(context)
                    .screens[TeacherCubit.get(context).currentIndex]);
      },
    );
  }
}
