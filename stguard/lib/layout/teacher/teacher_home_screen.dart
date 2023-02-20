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
            appBar: AppBar(),
            drawer: Drawer(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: screen_height*0.02, horizontal: screen_width*0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  height: screen_height * 0.3,
                  child: DrawerHeader(
                    padding: const EdgeInsets.all(0),
                    child: TeacherCubit.get(context).teacher != null
                        ? UserInfo(
                            userModel: TeacherCubit.get(context).teacher!,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: screen_width * 0.07,
                      color: defaultColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: screen_height * 0.02,
                ),
                DrawerItem(
                  text: 'Reset ID',
                  ontap: () => TeacherCubit.get(context).resetId(),
                  icon: Image(
                      image: AssetImage('assets/images/undo.png'),
                      width: screen_width * 0.07,
                      height: screen_height * 0.03),
                ),
                SizedBox(
                  height: screen_height * 0.02,
                ),
                DrawerItem(
                  text: 'Sign Out',
                  icon: Image(
                      color: Colors.red.shade300,
                      image: AssetImage('assets/images/signout.png'),
                      width: screen_width * 0.07,
                      height: screen_height * 0.03),
                  ontap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                'Are you sure?',
                                style: TextStyle(fontSize: 20),
                              ),
                              content: Text(
                                'Are you sure you want to log out?',
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      signOut(context);
                                    },
                                    child: Text("LOG OUT")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("NEVERMIND"))
                              ],
                            ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ]),
            )),
            bottomNavigationBar: TeacherCubit.get(context).teacherPath == null
                ? null
                : BottomNavigationBar(
                    currentIndex: TeacherCubit.get(context).currentIndex,
                    onTap: (index) =>
                        TeacherCubit.get(context).switchScreen(index),
                    items: [
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
