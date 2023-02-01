import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';

class TeacherHomeScreen extends StatelessWidget {
  TeacherHomeScreen({super.key});
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    requestWritePermission();
    return BlocConsumer<TeacherCubit, TeacherStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(),
            drawer: Drawer(
                child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(children: [
                DrawerHeader(
                    child: Image(
                      image: AssetImage('assets/images/settings.png'),
                      fit: BoxFit.scaleDown,
                    ),
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0)),
                DrawerItem(
                  text: 'Sign Out',
                  icon: Image(
                      image: AssetImage('assets/images/signout.png'),
                      width: 30,
                      height: 30),
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
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: TeacherCubit.get(context).currentIndex,
                onTap: (index) => TeacherCubit.get(context).switchScreen(index),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.history), label: 'History'),
                  BottomNavigationBarItem(icon: Icon(Icons.add), label: 'New')
                ]),
            body: TeacherCubit.get(context)
                .screens[TeacherCubit.get(context).currentIndex]);
      },
    );
  }
}
