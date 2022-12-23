import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/modules/parent/add_member/add_member_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ParentCubit()
        ..createDatabase()
        ..getStudentsData(),
      child: Builder(builder: (context) {
        ParentCubit.get(context).addNewTranscation();
        return BlocConsumer<ParentCubit, ParentStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(),
                drawer: Drawer(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(children: [
                    SizedBox(
                      height: 50,
                    ),
                    DrawerItem(
                      text: 'Sign Out',
                      icon: Icons.exit_to_app_rounded,
                      ontap: () {
                        signOut(context);
                      },
                    )
                  ]),
                )),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        'Welcome, Mohammad',
                        style: TextStyle(fontSize: 40),
                      ),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.blue[300]),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Family',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.zero,
                                height: 180,
                                width: 130,
                                child: Card(
                                  child: Container(
                                    width: double.infinity,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
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
                                            height: 20,
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
                        ],
                      ),
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
                                      buildActivityItem(ParentCubit.get(context)
                                          .canteen_transactions[index]),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        height: 5,
                                      ),
                                  itemCount: ParentCubit.get(context)
                                      .canteen_transactions
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
