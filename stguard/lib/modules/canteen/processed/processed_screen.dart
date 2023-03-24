import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/tap_to_pay_screen/tap_to_pay_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/themes.dart';

class ProcessedScreen extends StatelessWidget {
  const ProcessedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {
          if (state is StartListeningBuyerDataState) {
            navigateTo(context, const TapPayScreen());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                      color: defaultColor),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total Price',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 80,
                          ),
                          Text(
                            CanteenCubit.get(context)
                                .totalPrice
                                .toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Items Count',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 80,
                          ),
                          Text(
                            '${CanteenCubit.get(context).itemsCount}',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                       DefaultButton(
                           color: Colors.white,
                           onPressed: () {
                             CanteenCubit.get(context).listentoBuyer();
                           },
                           text: 'CONFIRM',
                           textColor: defaultColor),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
               
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ProductCartItem(
                          suffixWidget: Column(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  CanteenCubit.get(context).addQuantity(
                                     
                                      CanteenCubit.get(context)
                                          .selectedProducts
                                          .keys
                                          .toList()[index]);
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline_outlined,
                                  size: 20,
                                  color: defaultColor,
                                ),
                              ),
                              Text(
                                '${CanteenCubit.get(context).itemQuantities.values.toList()[index]}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  CanteenCubit.get(context).removeQuantity(
                                      CanteenCubit.get(context)
                                          .selectedProducts
                                          .keys
                                          .toList()[index]);
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline_outlined,
                                  size: 20,
                                  color: defaultColor,
                                ),
                              ),
                            ],
                          ),
                          productID: CanteenCubit.get(context)
                              .selectedProducts
                              .keys
                              .toList()[index],
                          product: CanteenCubit.get(context)
                              .selectedProducts
                              .values
                              .toList()[index]),
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount:
                          CanteenCubit.get(context).selectedProducts.length),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
