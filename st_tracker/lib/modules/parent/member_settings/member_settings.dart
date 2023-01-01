import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class MemberSettingsScreen extends StatelessWidget {
  studentModel? student;
  MemberSettingsScreen({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
    print(student!.location!['latitude'].runtimeType);
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    navigateTo(context, ParentHomeScreen());
                  },
                  icon: Icon(Icons.arrow_back)),
              title: Text("${student!.name!.split(' ')[0]}'s settings"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadiusDirectional.all(Radius.circular(10))),
                    width: screen_width,
                    height: screen_height * 0.15,
                    child: Card(
                      color: ParentCubit.get(context).isActivated &&
                              ParentCubit.get(context).IDs.contains(student!.id)
                          ? defaultColor
                          : Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 10, bottom: 10, right: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: screen_width * 0.5,
                                    child: Text(
                                      'Digital ID Number',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                                SizedBox(
                                  width: screen_width * 0.1,
                                ),
                                Text('${student!.id}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white54))
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    width: screen_width * 0.5,
                                    child: Text(
                                      ParentCubit.get(context).isActivated &&
                                              ParentCubit.get(context)
                                                  .IDs
                                                  .contains(student!.id)
                                          ? 'Activated'
                                          : 'Deactivated',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                                SizedBox(
                                  width: screen_width * 0.1,
                                ),
                                Switch(
                                  activeColor: defaultColor.shade700,
                                  activeTrackColor: defaultColor.shade100,
                                  value: ParentCubit.get(context).isActivated &&
                                      ParentCubit.get(context)
                                          .IDs
                                          .contains(student!.id),
                                  onChanged: (value) {},
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screen_height * 0.01,
                  ),
                  if (ParentCubit.get(context).isActivated &&
                      ParentCubit.get(context).IDs.contains(student!.id))
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(10))),
                          width: screen_width,
                          height: screen_height * 0.15,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image(
                                          width: screen_width * 0.07,
                                          height: screen_height * 0.03,
                                          image: AssetImage(
                                              'assets/images/map.png')),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Location',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 60,
                                      ),
                                      Text(
                                        'Last Seen',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${student!.location!['time']}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 190,
                                    height: 40,
                                    child: OutlinedButton(
                                      onPressed: () => ParentCubit.get(context)
                                          .openMap(
                                              lat: student!
                                                  .location!['latitude'],
                                              long: student!
                                                  .location!['longtitude']),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Find ${student!.name!.split(' ')[0]}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: defaultColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  Divider(),
                  MaterialButton(
                      color: Colors.red,
                      onPressed: () {
                        ParentCubit.get(context).showSettings();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Are you sure?',
                                style: TextStyle(fontSize: 20),
                              ),
                              content: Text(
                                  'If you deactivated your digital ID, you will not able to use it to spend and load up your account'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      ParentCubit.get(context).showSettings();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("CANCEL")),
                                TextButton(
                                    onPressed: () {
                                      ParentCubit.get(context)
                                          .deactivateDigitalID(student!.id!)
                                          .then((value) {
                                        navigateAndFinish(
                                            context, ParentHomeScreen());
                                        ParentCubit.get(context).showSettings();
                                      });
                                    },
                                    child: Text("YES, I'M SURE"))
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Unpair Digital ID',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                ],
              ),
            ));
      },
    );
  }
}
