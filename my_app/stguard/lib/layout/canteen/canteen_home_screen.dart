import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/modules/canteen/inventory/inventory_screen.dart';
import 'package:stguard/modules/canteen/join_community/join_community_screen.dart';
import 'package:stguard/modules/canteen/products/products_screen.dart';
import 'package:stguard/modules/login/login_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class CanteenHomeScreen extends StatelessWidget {
  const CanteenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CanteenCubit, CanteenStates>(
      listener: (context, state) 
      {
        if(state is UserSignOutSuccessState)
        {
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
                        padding: const EdgeInsets.only(left: 20, top: 40),
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
                            style: Theme.of(context).textTheme.headline4,
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
                                image: AssetImage('assets/images/signout.png'),
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
            body: state is GetCanteenPathLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ConditionalBuilder(
                    condition:
                        CanteenCubit.get(context).schoolCanteenPath != null,
                    builder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.center,
                                height: 450,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30)),
                                    color: Theme.of(context).primaryColor),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        const Image(
                                            color: Colors.white,
                                            height: 100,
                                            width: 100,
                                            image: AssetImage(
                                                'assets/images/canteen_sign.png')),
                                        Column(
                                          children: const [
                                            SizedBox(
                                              height: 60,
                                            ),
                                            Image(
                                                color: Colors.white,
                                                height: 200,
                                                width: 200,
                                                image: AssetImage(
                                                    'assets/images/home_store.png')),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
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
                                                      .headline5!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                                          .headline5!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    )),
                                                const SizedBox(
                                                  width: 30,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${CanteenCubit.get(context).canteenDetails != null ? CanteenCubit.get(context).canteenDetails!.dailyTransactions ?? 0 : 0}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      'Total Cash',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    )),
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${CanteenCubit.get(context).canteenDetails != null ? CanteenCubit.get(context).canteenDetails!.dailyRevenue != null ? CanteenCubit.get(context).canteenDetails!.dailyRevenue.toStringAsFixed(2) : 0.toStringAsFixed(2) : 0.toStringAsFixed(2)} EGP',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Row(
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
                                    textStyle:
                                        Theme.of(context).textTheme.headline6,
                                    onPressed: () =>
                                        navigateTo(context, ProductsScreen()),
                                  )),
                                  Expanded(
                                      child: DefaultButton2(
                                    width: 130,
                                    height: 130,
                                    text: 'Inventory',
                                    textStyle:
                                        Theme.of(context).textTheme.headline6,
                                    image: 'assets/images/inventory.png',
                                    imageHeight: 70,
                                    imageWidth: 70,
                                    onPressed: () => navigateTo(
                                        context, CanteenInventoryScreen()),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                    fallback: (context) => const CanteenJoinCommunityScreen()));
      },
    );
  }
}
