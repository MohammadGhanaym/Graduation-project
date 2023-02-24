import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/tap_to_pay_screen/tap_to_pay_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class ProcessedScreen extends StatelessWidget {
  const ProcessedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) 
        {
          if(state is StartListeningBuyerDataState)
          {
            navigateTo(context, const TapPayScreen());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: DefaultButton(
                      color: defaultColor.withOpacity(0.8),
                        onPressed: () {
                          CanteenCubit.get(context).listentoBuyer();
                          
                        },
                        text: 'CONFIRM'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ProductSearchItem(
                          suffixWidget: Column(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  CanteenCubit.get(context).updateQuantities(
                                      'add',
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
                                  CanteenCubit.get(context).updateQuantities(
                                      'remove',
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
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
