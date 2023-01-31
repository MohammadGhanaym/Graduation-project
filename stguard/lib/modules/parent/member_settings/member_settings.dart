import 'package:cloud_firestore/cloud_firestore.dart';
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
  Widget build(BuildContext Maincontext) {
    print(student!.location!['latitude'].runtimeType);
    screen_height = MediaQuery.of(Maincontext).size.height;
    screen_width = MediaQuery.of(Maincontext).size.width;
    return Builder(
      builder: (context) {
        ParentCubit.get(context).getMaxPocketMoney(id: student!.id);
        ParentCubit.get(context).getAllergies(student!.id);
        ParentCubit.get(context).getActiveState(student!.id!);
        return BlocConsumer<ParentCubit, ParentStates>(
          listener: (context, state) {
            if (state is UnpairDigitalIDSuccess) {
              navigateAndFinish(context, ParentHomeScreen());
              ParentCubit.get(context).showSettings();
              ParentCubit.get(context).changeSettingsVisibility();
            }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  leading: MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ParentCubit.get(context).hideBottomSheet();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: Text("${student!.name!.split(' ')[0]}'s settings"),
                ),
                bottomSheet: ParentCubit.get(context).isBottomSheetShown
                    ? BottomSheet(
                        onClosing: () {},
                        builder: (context) => Container(
                            color: defaultColor.withOpacity(0.8),
                            width: screen_width,
                            child: MaterialButton(
                                onPressed: () {
                                  ParentCubit.get(context)
                                      .updatePocketMoney(id: student!.id);
                                  ParentCubit.get(context).hideBottomSheet();
                                },
                                child: Text('Give',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))))
                    : null,
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(10))),
                        width: screen_width,
                        height: screen_height * 0.15,
                        child: Card(
                          color: ParentCubit.get(context).isPaired &&
                                      ParentCubit.get(context)
                                          .studentIDs
                                          .contains(student!.id) &&
                                  ParentCubit.get(context).active
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
                                          ParentCubit.get(context)
                                                      .isPaired &&
                                                  ParentCubit.get(context)
                                                      .studentIDs
                                                      .contains(student!.id) && ParentCubit.get(context).active
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
                                      value: ParentCubit.get(context)
                                              .isPaired &&
                                          ParentCubit.get(context)
                                              .studentIDs
                                              .contains(student!.id) && ParentCubit.get(context).active,
                                      onChanged: (value) {
                                        ParentCubit.get(context)
                                            .changeDigitalIDState(student!.id!);
                                      },
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
                      Visibility(
                        visible: ParentCubit.get(context).settingsVisibility,
                        maintainState: true,
                        maintainAnimation: true,
                        child: AnimatedOpacity(
                          opacity: (ParentCubit.get(context).isPaired &&
                                  ParentCubit.get(context)
                                      .studentIDs
                                      .contains(student!.id))
                              ? 1
                              : 0.0,
                          onEnd: () => ParentCubit.get(context)
                              .changeSettingsVisibility(),
                          duration: Duration(milliseconds: 500),
                          child: Column(
                            children: [
                              // location
                              SettingsCard(
                                card_width: screen_width,
                                card_height: screen_height * 0.15,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image(
                                          width: screen_width * 0.08,
                                          height: screen_height * 0.04,
                                          image: AssetImage(
                                              'assets/images/map.png')),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            'Location',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: screen_width * 0.05,
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
                              SizedBox(height: screen_height * 0.01),
                              SettingsCard(
                                  card_width: screen_width,
                                  card_height: screen_height * 0.18,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image(
                                            width: screen_width * 0.08,
                                            height: screen_height * 0.04,
                                            image: AssetImage(
                                                'assets/images/pocket_money.png')),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Spending Limits',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          alignment:
                                              AlignmentDirectional.center,
                                          width: screen_width * 0.18,
                                          height: screen_height * 0.04,
                                          decoration: BoxDecoration(
                                              color: defaultColor,
                                              borderRadius:
                                                  BorderRadiusDirectional
                                                      .circular(15)),
                                          child: Text(
                                            '${ParentCubit.get(context).pocket_money.round()} EGP',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: screen_width * 0.08,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screen_height * 0.01,
                                    ),
                                    SliderBuilder()
                                  ]),
                              SizedBox(
                                height: screen_height * 0.01,
                              ),
                              SettingsCard(
                                  card_width: screen_width,
                                  card_height: screen_height * 0.22,
                                  children: [
                                    Row(
                                      children: [
                                        ImageIcon(
                                          AssetImage(
                                              'assets/images/blood-drop.png'),
                                          size: screen_width * 0.09,
                                          color: defaultColor,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Allergens',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                    Text(
                                      'By adding allergens, your child will not be able to purchase anything that marked by a vendor containing them',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Expanded(
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) =>
                                                AllergenItem(
                                                    id: student!.id,
                                                    width: screen_width * 0.18,
                                                    height:
                                                        screen_height * 0.04,
                                                    icon:
                                                        ParentCubit.get(context)
                                                            .allergens
                                                            .reversed
                                                            .toList()[index],
                                                    context: context),
                                            separatorBuilder: (context,
                                                    index) =>
                                                SizedBox(
                                                  width: screen_width * 0.01,
                                                ),
                                            itemCount: ParentCubit.get(context)
                                                .allergens
                                                .length))
                                  ])
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      MaterialButton(
                        child: Text(
                          'Unpair Digital ID',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                                            .unpairDigitalID(student!.id!);
                                      },
                                      child: Text("YES, I'M SURE"))
                                ],
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
