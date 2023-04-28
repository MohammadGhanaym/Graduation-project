import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/modules/login/login_screen.dart';
import 'package:stguard/modules/parent/credit_card/credit_card_screen.dart';
import 'package:stguard/modules/parent/pick_school/pick_school_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/Themes.dart';

class ParentHomeScreen extends StatelessWidget {
  ParentHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    late BuildContext parentBuildContext;
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context1, state) async {
        if (state is GetCountriesSucessState) {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 30,
                          height: 5,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: defaultColor.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Pick your country',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => CountryItem(
                              country: ParentCubit.get(context)
                                  .countries[index]
                                  .name,
                              onTap: () => ParentCubit.get(context)
                                  .pickCountry(index),
                            ),
                        separatorBuilder: (context, index) =>
                            const Divider(),
                        itemCount:
                            ParentCubit.get(context).countries.length),
                  ),
                ],
              ),
            ),
          );
        } else if (state is GetSchoolsSucessState) {
          navigateTo(
              context,
              const PickSchoolScreen());
        } else if (state is PickCountryState) {
          await ParentCubit.get(context).getSchools();
        } else if (state is UserSignOutSuccessState) {
          navigateAndFinish(context, LoginScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
            ),
            drawer: Drawer(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Expanded(
                    child: SizedBox(
                      height: 300,
                      child: DrawerHeader(
                        padding: const EdgeInsets.only(
                            top: 40, left: 20, right: 20),
                        child: ParentCubit.get(context).parent != null
                            ? UserInfo(
                                userModel: ParentCubit.get(context).parent!,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Settings',
                                style: Theme.of(context).textTheme.headline4),
                            const SizedBox(
                              height: 20,
                            ),
                            DrawerItem(
                              text: 'Add Family Member',
                              icon: const Image(
                                image: AssetImage('assets/images/member.png'),
                                width: 40,
                                height: 40,
                              ),
                              ontap: () async =>
                                  await ParentCubit.get(context)
                                      .getCountries(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DrawerItem(
                              text: 'Recharge',
                              icon: const Image(
                                image:
                                    AssetImage('assets/images/recharge.png'),
                                width: 40,
                                height: 40,
                              ),
                              ontap: () => navigateTo(
                                  context,
                                  CreditCardScreen()),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DrawerItem(
                              text: 'Clear History',
                              icon: const Image(
                                  image:
                                      AssetImage('assets/images/delete.png'),
                                  width: 40,
                                  height: 40),
                              ontap: () async =>
                                  await ParentCubit.get(context)
                                      .clearHistory(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DrawerItem(
                              text: 'Sign Out',
                              icon: const Image(
                                image:
                                    AssetImage('assets/images/signout.png'),
                                width: 40,
                                height: 40,
                              ),
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
                                    ParentCubit.get(context).signOut();
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )),
                ])),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // balance
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: AlignmentDirectional.topStart,
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        color: Theme.of(context).primaryColor),
                    child: state is GetUserInfoLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 170,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Balance',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          ParentCubit.get(context).parent !=
                                                  null
                                              ? ParentCubit.get(context)
                                                  .parent!
                                                  .balance
                                                  .toStringAsFixed(2)
                                              : '0.00',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  const Image(
                                    color: Colors.white,
                                    image:
                                        AssetImage('assets/images/purse.png'),
                                    width: 100,
                                    height: 100,
                                  )
                                ],
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // family
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Family',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 5,
                        ),
                        ConditionalBuilder(
                            condition: state is! GetStudentDataLoading,
                            builder: (context) => ParentCubit.get(context)
                                    .studentsData
                                    .isNotEmpty
                                ? SizedBox(
                                    height: 140,
                                    width: double.infinity,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            FamilyMemberCard(
                                              ParentCubit.get(context)
                                                  .studentsData
                                                  .values
                                                  .toList()[index],
                                            ),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              width: 5,
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
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
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
                                                            onPressed:
                                                                () async {
                                                              await ParentCubit
                                                                      .get(
                                                                          context)
                                                                  .getCountries();
                                                            },
                                                            icon: const Icon(
                                                                Icons.add))),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                          'Add Family Member'))
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            fallback: (context) => const SizedBox(
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Activity',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 5,
                        ),
                        //activity
                        ConditionalBuilder(
                          condition: state is! ParentGetDataBaseLoadingState,
                          builder: (context) => ParentCubit.get(context)
                                      .activities
                                      .isNotEmpty &&
                                  ParentCubit.get(context)
                                      .studentsData
                                      .isNotEmpty
                              ? ListView.separated(
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      ActivityItem(
                                          model: ParentCubit.get(context)
                                              .activities[index],
                                          studentsData:
                                              ParentCubit.get(context)
                                                  .studentsData
                                                  .values
                                                  .toList()),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 5,
                                      ),
                                  itemCount: ParentCubit.get(context)
                                      .activities
                                      .length)
                              : Center(
                                  child: SizedBox(
                                    width: 200,
                                    height: 230,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Image(
                                          height: 130,
                                          width: 130,
                                          image: AssetImage(
                                              'assets/images/no_activity.png'),
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
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }
}
