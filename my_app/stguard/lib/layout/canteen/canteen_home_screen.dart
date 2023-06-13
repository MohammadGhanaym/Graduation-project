import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/modules/canteen/inventory/inventory_screen.dart';
import 'package:stguard/modules/canteen/join_community/join_community_screen.dart';
import 'package:stguard/modules/canteen/products/products_screen.dart';
import 'package:stguard/modules/canteen/trans_details/trans_details_screen.dart';
import 'package:stguard/modules/login/login_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/internet_cubit/cubit.dart';
import 'package:stguard/shared/styles/themes.dart';

class CanteenHomeScreen extends StatelessWidget {
  const CanteenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CanteenCubit.get(context)
      ..getCanteenInfo()
      ..getCanteenPath();
    return BlocListener<InternetCubit, ConnectionStatus>(
      listener: (context, state) {
        if (state == ConnectionStatus.disconnected) {
          showSnackBar(context,
              message: 'You are currently offline.', icon: Icons.wifi_off);
        } else if (state == ConnectionStatus.connected) {
          showSnackBar(context,
              message: 'Your internet connection has been restored.',
              icon: Icons.wifi);
        }
      },
      child: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {
          if (state is UserSignOutSuccessState) {
            navigateAndFinish(context, LoginScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
              ),
              drawer: Drawer(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Expanded(
                      child: SizedBox(
                        height: 300,
                        child: DrawerHeader(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: CanteenCubit.get(context).canteen != null
                              ? UserInfo(
                                  userModel: CanteenCubit.get(context).canteen!,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: defaultColor),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DrawerItem(
                              text: 'Reset ID',
                              ontap: () => CanteenCubit.get(context).resetId(),
                              icon: const Image(
                                  color: defaultColor,
                                  fit: BoxFit.scaleDown,
                                  image: AssetImage('assets/images/undo.png'),
                                  width: 35,
                                  height: 35),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            DrawerItem(
                              text: 'Sign Out',
                              icon: const Image(
                                  color: defaultColor,
                                  image:
                                      AssetImage('assets/images/signout.png'),
                                  width: 35,
                                  height: 35),
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
                                    CanteenCubit.get(context).signOut();
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
              body: CanteenCubit.get(context).canteenPathLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ConditionalBuilder(
                      condition:
                          CanteenCubit.get(context).schoolCanteenPath != null,
                      builder: (context) => SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  alignment: AlignmentDirectional.center,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(30),
                                          bottomRight: Radius.circular(30)),
                                      color: Theme.of(context).primaryColor),
                                  child: Container(
                                    height: 160,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                30)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Image(
                                                  width: 35,
                                                  height: 35,
                                                  image: AssetImage(
                                                      'assets/images/sales.png')),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Daily Sales Report',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'OpenSans'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    'Orders Counts',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${CanteenCubit.get(context).canteenDetails != null ? CanteenCubit.get(context).canteenDetails!.dailyTransactions ?? 0 : 0}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    'Total Cash',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  currencyFormat(CanteenCubit
                                                                  .get(context)
                                                              .canteenDetails !=
                                                          null
                                                      ? CanteenCubit.get(
                                                                  context)
                                                              .canteenDetails!
                                                              .dailyRevenue ??
                                                          0
                                                      : 0),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: DefaultButton2(
                                      width: 130,
                                      height: 130,
                                      image: 'assets/images/menu.png',
                                      text: 'Menu',
                                      imageWidth: 70,
                                      imageHeight: 70,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                      onPressed: () =>
                                          navigateTo(context, ProductsScreen()),
                                    )),
                                    Expanded(
                                        child: DefaultButton2(
                                      width: 130,
                                      height: 130,
                                      text: 'Inventory',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                      image: 'assets/images/inventory.png',
                                      imageHeight: 70,
                                      imageWidth: 70,
                                      onPressed: () => navigateTo(
                                          context, CanteenInventoryScreen()),
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Transaction',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          const Spacer(),
                                          TextButton(
                                              onPressed: () {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2020),
                                                        lastDate:
                                                            DateTime.now())
                                                    .then((value) {
                                                  CanteenCubit.get(context)
                                                      .setTransDate(
                                                          date: value);
                                                });
                                              },
                                              child: Text(
                                                checkToday(CanteenCubit.get(
                                                            context)
                                                        .getTransBy) ??
                                                    getDate(
                                                        CanteenCubit.get(
                                                                context)
                                                            .getTransBy,
                                                        format: 'dd/MM/yyyy'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        color: defaultColor),
                                              )),
                                          const SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ConditionalBuilder(
                                        condition: !CanteenCubit.get(context)
                                            .getTransLoading,
                                        builder: (context) =>
                                            ConditionalBuilder(
                                          condition: CanteenCubit.get(context)
                                              .transactions!
                                              .isNotEmpty,
                                          builder: (context) =>
                                              ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                TransactionItem(
                                                    onTap: () {
                                                      navigateTo(
                                                          context, CanteeenTransactionDetailsScreen(trans: 
                                                          CanteenCubit.get(
                                                            context)
                                                        .transactions![index],));
                                                    },
                                                    trans: CanteenCubit.get(
                                                            context)
                                                        .transactions![index]),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              height: 5,
                                            ),
                                            itemCount: CanteenCubit.get(context)
                                                .transactions!
                                                .length,
                                          ),
                                          fallback: (context) => Padding(
                                            padding: const EdgeInsets.only(
                                                right: 40,
                                                left: 40,
                                                bottom: 40),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  const Image(
                                                      height: 150,
                                                      width: 150,
                                                      image: AssetImage(
                                                          'assets/images/no_activity.png')),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'No Transaction Found',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        fallback: (context) => const Center(
                                            child: CircularProgressIndicator()),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                      fallback: (context) =>
                          const CanteenJoinCommunityScreen()));
        },
      ),
    );
  }
}
