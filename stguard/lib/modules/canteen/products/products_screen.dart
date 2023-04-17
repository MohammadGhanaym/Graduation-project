import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/canteen_home_screen.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/modules/canteen/processed/processed_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class ProductsScreen extends StatelessWidget {
  var searchController = TextEditingController();
  ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanteenCubit, CanteenStates>(
      builder: (context, state) {
        return WillPopScope(
            child: Scaffold(
                body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              color: defaultColor,
                              onPressed: () async {
                                if (CanteenCubit.get(context)
                                    .selectedProducts
                                    .isNotEmpty) {
                                  showDefaultDialog(
                                    context,
                                    title: 'Are you sure?',
                                    content: const Text(
                                        'If you leave this screen now, the selected product will be cancelled. Are you sure you want to proceed?'),
                                    buttonText1: 'Cancel',
                                    buttonText2: 'Leave',
                                    onPressed1: ()  {
                                      Navigator.of(context).pop();
                                      
                                    },
                                    onPressed2: () async{
                                      CanteenCubit.get(context)
                                          .cancelSelectedProducts();
                                      await CanteenCubit.get(context)
                                          .getProducts();
                                          
                                      navigateAndFinish(
                                          context, const CanteenHomeScreen());
                                    },
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  await CanteenCubit.get(context).getProducts();
                                }
                              },
                              icon: const Icon(Icons.arrow_back)),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: SizedBox(
                                child: SearchTextFormField(
                              searchController: searchController,
                              onChanged: (p0) => CanteenCubit.get(context)
                                  .getProducts(search: p0),
                            )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          PopupMenuButton(
                            icon: const ImageIcon(
                                color: defaultColor,
                                AssetImage('assets/images/adjust.png')),
                            itemBuilder: (context) => List.generate(
                                CanteenCubit.get(context).categories.length,
                                (index) => PopupMenuItem(
                                    value: CanteenCubit.get(context)
                                        .categories[index],
                                    child: Text(
                                      CanteenCubit.get(context)
                                          .categories[index],
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ))),
                            onSelected: (category) {
                              print(category);
                              CanteenCubit.get(context)
                                  .getProducts(category: category);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ConditionalBuilder(
                        condition: state is! GetProductsLoadingState,
                        fallback: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        builder: (context) => Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                                              builder: (context) =>
                                                  DefaultButton(
                                                      text: 'Processed',
                                                      color: defaultColor
                                                          .withOpacity(0.8),
                                                      onPressed: () {
                                                        CanteenCubit.get(
                                                                context)
                                                            .calTotalPriceAndCalories();
                                                        navigateTo(context,
                                                            const ProcessedScreen());
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
                      ),
                    ],
                  ),
                ),
              ),
            )),
            onWillPop: () async {
              if (CanteenCubit.get(context).bottomSheetShown) {
                await showDefaultDialog(
                  context,
                  title: 'Are you sure?',
                  content: const Text(
                      'If you leave this screen now, the selected product will be cancelled. Are you sure you want to proceed?'),
                  buttonText1: 'Cancel',
                  buttonText2: 'Leave',
                  onPressed1: () => Navigator.of(context).pop(),
                  onPressed2: () {
                    CanteenCubit.get(context).cancelSelectedProducts();
                    navigateAndFinish(context, const CanteenHomeScreen());
                  },
                );
                return false;
              }
              return true;
            });
      },
    );
  }
}
