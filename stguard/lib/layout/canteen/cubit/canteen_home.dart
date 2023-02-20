import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/add_product/add_product_screen.dart';
import 'package:st_tracker/modules/canteen/join_community/join_community_screen.dart';
import 'package:st_tracker/modules/canteen/products/products_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CanteenHome extends StatelessWidget {
  const CanteenHome({super.key});

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
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image(
                                    width: 30,
                                    height: 30,
                                    image:
                                        AssetImage('assets/images/sales.png')),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Daily Sales Report',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Purchases',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    )),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  '0',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Revenue',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    )),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  '0.00 EGP',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image(
                      width: 200,
                      image: AssetImage('assets/images/store.png')),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          navigateTo(context, ProductsScreen());
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image(
                                    image: AssetImage('assets/images/candies.png'),
                                    width: 40,
                                    height: 40),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Canteen Menu', style: Theme.of(context).textTheme.headline6)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MaterialButton(
                          onPressed: () {
                            navigateTo(context, AddProductScreen());
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/store-setting.png'),
                                      width: 40,
                                      height: 40),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Canteen Inventory', style: Theme.of(context).textTheme.headline6,)
                                ],
                              ),
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
