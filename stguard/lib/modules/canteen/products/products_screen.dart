import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/canteen_home_screen.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/processed/processed_screen.dart';
import 'package:st_tracker/modules/canteen/search/search_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (CanteenCubit.get(context).selectedProducts.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text(
                          'If you leave this screen now, the selected product will be cancelled. Are you sure you want to proceed?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ElevatedButton(
                          child: const Text('Leave'),
                          onPressed: () {
                            CanteenCubit.get(context).cancelSelectedProducts();
                            navigateAndFinish(context, CanteenHomeScreen());
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  navigateTo(context, SearchScreen());
                },
                icon: const Icon(Icons.search)),
            PopupMenuButton(
              icon: const ImageIcon(AssetImage('assets/images/menu.png')),
              itemBuilder: (context) => List.generate(
                  CanteenCubit.get(context).categories.length,
                  (index) => PopupMenuItem(
                      value: CanteenCubit.get(context).categories[index],
                      child: Text(
                        CanteenCubit.get(context).categories[index],
                        style: Theme.of(context).textTheme.bodyText1,
                      ))),
              onSelected: (category) {
                print(category);
                CanteenCubit.get(context).getProducts(category: category);
              },
            ),
          ],
        ),
        body: BlocConsumer<CanteenCubit, CanteenStates>(
          listener: (context, state) {
            
          },
          builder: (context, state) {
            return ConditionalBuilder(
              condition: state is! GetProductsLoadingState,
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
              builder: (context) => Padding(
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: 1 / 1.4,
                  children: List.generate(
                      CanteenCubit.get(context).products.length,
                      (index) => CanteenProductCard(
                            productID: CanteenCubit.get(context)
                                .products
                                .keys
                                .toList()[index],
                            product: CanteenCubit.get(context)
                                .products
                                .values
                                .toList()[index],
                            onTap: () {
                              CanteenCubit.get(context).selectProduct(
                                  CanteenCubit.get(context)
                                      .products
                                      .keys
                                      .toList()[index],
                                  CanteenCubit.get(context)
                                      .products
                                      .values
                                      .toList()[index]);
                              if (CanteenCubit.get(context)
                                  .selectedProducts
                                  .isNotEmpty) {
                                if (!CanteenCubit.get(context)
                                    .bottomSheetShown) {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) => DefaultButton(
                                        text: 'Processed',
                                        color: defaultColor.withOpacity(0.8),
                                        onPressed: () {
                                          CanteenCubit.get(context)
                                              .calTotalPrice();
                                          navigateTo(context, const ProcessedScreen());
                                        }),
                                  );
                                  CanteenCubit.get(context)
                                      .showBottomSheet(true);
                                }
                              } else {
                                if (CanteenCubit.get(context)
                                    .bottomSheetShown) {
                                  Navigator.pop(context);
                                  CanteenCubit.get(context)
                                      .showBottomSheet(false);
                                }
                              }
                            },
                          )),
                ),
              ),
            );
          },
        ));
  }
}
