import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/modules/parent/add_member/add_member_screen.dart';
import 'package:st_tracker/modules/parent/recharge/recharge_screen.dart';
import 'package:st_tracker/shared/components/components.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      ParentCubit.get(context).createDatabase();
      ParentCubit.get(context).getStudentsData();
      ParentCubit.get(context).initBackgroundService(action: 'start');
      ParentCubit.get(context).getBalance();
      
      return BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
              ),
              drawer: Drawer(
                  child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: ListView(children: [
                  DrawerHeader(
                      child: Image(
                        image: AssetImage('assets/images/settings.png'),
                        fit: BoxFit.scaleDown,
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0)),
                  DrawerItem(
                    text: 'Add Family Member',
                    icon: Image(
                      image: AssetImage('assets/images/member.png'),
                      width: 30,
                      height: 30,
                    ),
                    ontap: () => navigateTo(context, AddMember()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DrawerItem(
                    text: 'Recharge',
                    icon: Image(
                      image: AssetImage('assets/images/recharge.png'),
                      width: 30,
                      height: 30,
                    ),
                    ontap: () => navigateTo(context, RechargeScreen()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DrawerItem(
                    text: 'Clear History',
                    icon: Image(
                        image: AssetImage('assets/images/delete.png'),
                        width: 30,
                        height: 30),
                    ontap: () => ParentCubit.get(context).clearHistory(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // balance
                  Container(
                    padding: EdgeInsets.all(20),
                    alignment: AlignmentDirectional.topStart,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${ParentCubit.get(context).balance.toStringAsFixed(2)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            Image(
                              color: Colors.white,
                              image: AssetImage('assets/images/purse.png'),
                              width: 100,
                              height: 100,
                            )
                          ],
                        ),
                      ],
                    ),
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // family
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Family',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  //family
                  ConditionalBuilder(
                      condition: ParentCubit.get(context).studentsData.isNotEmpty,
                      builder: (context) => ParentCubit.get(context)
                              .studentsData
                              .isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: SizedBox(
                                height: 140,
                                width: double.infinity,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        FamilyMemberCard(
                                          ParentCubit.get(context)
                                              .studentsData[index],
                                        ),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          width: 5,
                                        ),
                                    itemCount: ParentCubit.get(context)
                                        .studentsData
                                        .length),
                              ),
                            )
                          : Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    height: 150,
                                    width: 130,
                                    child: Card(
                                      child: Container(
                                        width: double.infinity,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              CircleAvatar(
                                                radius: 36,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                                child: CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          navigateTo(
                                                              context,
                                                              BlocProvider.value(
                                                                  value: ParentCubit
                                                                      .get(
                                                                          context),
                                                                  child:
                                                                      AddMember()));
                                                        },
                                                        icon: Icon(Icons.add))),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  width: 80,
                                                  child:
                                                      Text('Add Family Member'))
                                            ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      fallback: (context) => Center(
                            child: CircularProgressIndicator(),
                          )),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Activity',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          //activity
                          ConditionalBuilder(
                            condition: state is! ParentGetDataBaseLoadingState,
                            builder: (context) => ParentCubit.get(context)
                                    .activities
                                    .isNotEmpty
                                ? Expanded(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            ActivityItem(
                                                model: ParentCubit.get(context)
                                                    .activities[index],
                                                studentsData:
                                                    ParentCubit.get(context)
                                                        .studentsData),
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: 5,
                                            ),
                                        itemCount: ParentCubit.get(context)
                                            .activities
                                            .length),
                                  )
                                : Center(
                                    child: Container(
                                      width: 200,
                                      height: 230,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                            height: 130,
                                            width: 130,
                                            image: AssetImage(
                                                'assets/images/searching.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'No activity Found',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            fallback: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        },
      );
    });
  }
}
