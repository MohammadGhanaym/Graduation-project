import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/join_community/join_community_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CanteenHomeScreen extends StatelessWidget {
  const CanteenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CanteenCubit, CanteenStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(),
            drawer: Drawer(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 300,
                          child: DrawerHeader(
                            padding: EdgeInsets.all(20),
                            child: CanteenCubit.get(context).canteen != null
                                ? UserInfo(
                                    userModel: CanteenCubit.get(context).canteen!,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
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
                                height: 10,
                              ),
                              DrawerItem(
                                text: 'Reset ID',
                                ontap: () => CanteenCubit.get(context).resetId(),
                                icon: Image(
                                    image: AssetImage('assets/images/undo.png'),
                                    width: 20,
                                    height: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DrawerItem(
                                text: 'Sign Out',
                                icon: Image(
                                    color: Colors.red.shade300,
                                    image: AssetImage('assets/images/signout.png'),
                                    width: 20,
                                    height: 20),
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
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])),
            bottomNavigationBar: CanteenCubit.get(context).canteenPath == null
                ? null
                : BottomNavigationBar(
                    currentIndex: CanteenCubit.get(context).currentIndex,
                    onTap: (index) =>
                        CanteenCubit.get(context).switchScreen(index),
                    items:const [
                        BottomNavigationBarItem(
                            icon: ImageIcon(
                                AssetImage('assets/images/store-setting.png')),
                            label: 'Add'),
                        BottomNavigationBarItem(
                            icon: ImageIcon(AssetImage(
                                'assets/images/school-cafeteria.png')),
                            label: 'Canteen')
                      ]),
            body: state is GetCanteenPathLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CanteenCubit.get(context).canteenPath == null
                    ? CanteenJoinCommunityScreen()
                    : CanteenCubit.get(context)
                        .screens[CanteenCubit.get(context).currentIndex]);
      },
    );
  }
}
