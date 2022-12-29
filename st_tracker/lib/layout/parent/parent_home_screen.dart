import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/modules/parent/add_member/add_member_screen.dart';
import 'package:st_tracker/shared/components/components.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentCubit()
        ..createDatabase()
        ..getStudentsData()
        ..initBackgroundService(),
      child: Builder(builder: (context) {
        ParentCubit.get(context).addNewTranscation();
        ParentCubit.get(context).addNewAttendance();
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
                      color: Theme.of(context).primaryColor,
                      image: AssetImage('assets/images/profile.png'),
                      fit: BoxFit.scaleDown,
                    )),
                    DrawerItem(
                      text: 'Add Family Member',
                      icon: Icons.card_membership,
                      ontap: () => navigateTo(context, AddMember()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DrawerItem(
                      text: 'Clear History',
                      icon: Icons.delete_outlined,
                      ontap: () => ParentCubit.get(context).clearHistory(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DrawerItem(
                      text: 'Sign Out',
                      icon: Icons.logout_outlined,
                      ontap: () {
                        signOut(context);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ]),
                )),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                      '1000.0 EGP',
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
                    ParentCubit.get(context).studentsData.isNotEmpty
                        ? SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    buildFamilyMemberCard(
                                        ParentCubit.get(context)
                                            .studentsData[index],
                                        context),
                                separatorBuilder: (context, index) => SizedBox(
                                      width: 10,
                                    ),
                                itemCount: ParentCubit.get(context)
                                    .studentsData
                                    .length),
                          )
                        : Row(
                            children: [
                              Container(
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
                                            radius: 41,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                    onPressed: () {
                                                      navigateTo(
                                                          context,
                                                          BlocProvider.value(
                                                              value: ParentCubit
                                                                  .get(context),
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
                                              child: Text('Add Family Member'))
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                            Expanded(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      buildActivityItem(
                                          ParentCubit.get(context)
                                              .activities[index],
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
                          ],
                        ),
                      ),
                    )
                  ],
                ));
          },
        );
      }),
    );
  }
}
