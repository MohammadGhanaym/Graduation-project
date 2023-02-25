import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/inventory/inventory_screen.dart';
import 'package:st_tracker/modules/canteen/join_community/join_community_screen.dart';
import 'package:st_tracker/modules/canteen/products/products_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CanteenHomeScreen extends StatelessWidget {
  const CanteenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CanteenCubit, CanteenStates>(
      listener: (context, state) {
        if (state is NeedtoJoinCommunityState) {
          navigateAndFinish(context, CanteenJoinCommunityScreen());
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
                        padding: const EdgeInsets.all(20),
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
                            icon: const Image(
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
                                image: const AssetImage(
                                    'assets/images/signout.png'),
                                width: 20,
                                height: 20),
                            ontap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Are you sure?',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        content: const Text(
                                          'Are you sure you want to log out?',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                signOut(context);
                                              },
                                              child: const Text("LOG OUT")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("NEVERMIND"))
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
            body: ConditionalBuilder(
              condition: CanteenCubit.get(context).schoolCanteenPath != null,
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    const Image(
                                        color: Colors.white,
                                        height: 200,
                                        width: 200,
                                        image: AssetImage(
                                            'assets/images/home_store.png')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadiusDirectional.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Image(
                                          width: 30,
                                          height: 30,
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
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 150,
                                          child: Text(
                                            'Transactions',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Text(
                                        '${CanteenCubit.get(context).canteenDetails != null ? CanteenCubit.get(context).canteenDetails!.dailyTransactions ?? 0 : 0}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                                            'Revenue',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        '${CanteenCubit.get(context).canteenDetails != null ? CanteenCubit.get(context).canteenDetails!.dailyRevenue != null ? CanteenCubit.get(context).canteenDetails!.dailyRevenue.toStringAsFixed(2) : 0.toStringAsFixed(2) : 0.toStringAsFixed(2)} EGP',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                    height: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              navigateTo(context, ProductsScreen());
                            },
                            child: SizedBox(
                              width: 130,
                              height: 130,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Image(
                                          image: AssetImage(
                                              'assets/images/candies.png'),
                                          width: 50,
                                          height: 50),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text('Menu',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                              onPressed: () {
                                CanteenCubit.get(context).getSearchResults();
                                navigateTo(context, CanteenInventoryScreen());
                              },
                              child: SizedBox(
                                width: 130,
                                height: 130,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Image(
                                            image: AssetImage(
                                                'assets/images/store-setting.png'),
                                            width: 50,
                                            height: 50),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Inventory',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ));
      },
    );
  }
}
