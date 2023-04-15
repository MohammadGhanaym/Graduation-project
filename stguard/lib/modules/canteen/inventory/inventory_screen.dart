import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/modules/canteen/add_product/add_product_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class CanteenInventoryScreen extends StatelessWidget {
  CanteenInventoryScreen({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CanteenCubit, CanteenStates>(
      listener: (context, state) {
        if (state is UploadItemDataSuccessState) {
          ShowToast(
              message: 'New Item is added Successfully',
              state: ToastStates.SUCCESS);
          Navigator.pop(context);
        }

        if (state is UpdatePriceSuccessState) {
          ShowToast(
              message: 'Price is updated successfully',
              state: ToastStates.SUCCESS);
          Navigator.pop(context);
        }

        if (state is DeleteItemSuccessState) {
          ShowToast(
              message: 'Item is deleted successfully',
              state: ToastStates.SUCCESS);
          Navigator.pop(context);
        }
        if (state is DeleteCategorySuccessState) {
          ShowToast(
              message: 'Category is deleted successfully',
              state: ToastStates.SUCCESS);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await CanteenCubit.get(context).getProducts();
                    },
                    icon: const Icon(Icons.arrow_back))),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: DefaultButton(
                            color: defaultColor.withOpacity(0.8),
                            onPressed: (() {
                              CanteenCubit.get(context).getAllergies();
                              navigateTo(context, AddProductScreen());
                            }),
                            text: 'Add New Item'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                      child: Text(
                        'Delete Category',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 55,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              InventoryCategoryCard(
                                category: CanteenCubit.get(context)
                                    .categories
                                    .where((element) => element != 'All')
                                    .toList()[index],
                                onPressed: () async {
                                  await showDefaultDialog(context,
                                      content: Text(
                                          'Are you certain that you want to delete this category? Deleting this category will also delete all items within it',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                      title: 'Are you sure?',
                                      buttonText1: 'Cancel',
                                      buttonText2: 'Delete', onPressed1: () {
                                    Navigator.pop(context);
                                  }, onPressed2: () {
                                    CanteenCubit.get(context).deleteCategory(
                                        CanteenCubit.get(context)
                                            .categories
                                            .where(
                                                (element) => element != 'All')
                                            .toList()[index]);
                                  });
                                },
                              ),
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 5,
                              ),
                          itemCount: CanteenCubit.get(context)
                              .categories
                              .where((element) => element != 'All')
                              .toList()
                              .length),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                      child: Text('Edit Item',
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 20),
                        child: SearchTextFormField(
                            searchController: searchController,
                            onChanged: (p0) {
                              CanteenCubit.get(context).getProducts(search: p0);
                            })),
                    const SizedBox(
                      height: 5,
                    ),
                    state is UpdatePriceLoadingState ||
                            state is DeleteItemLoadingState ||
                            state is GetInventorySearchResultssLoadingState
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    ProductSearchItem(
                                        productID: CanteenCubit.get(context)
                                            .products
                                            .keys
                                            .toList()[index],
                                        product: CanteenCubit.get(context)
                                            .products
                                            .values
                                            .toList()[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 10,
                                    ),
                                itemCount:
                                    CanteenCubit.get(context).products.length),
                          )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
