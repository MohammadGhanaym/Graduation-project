import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/add_product/add_product_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CanteenInventoryScreen extends StatelessWidget {
  CanteenInventoryScreen({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
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
        },
        builder: (context, state) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
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
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DefaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Search must not be empty';
                          }
                          return null;
                        },
                        label: 'Search',
                        prefix: Icons.search,
                        onChange: (p0) {
                          CanteenCubit.get(context)
                              .getInventorySearchResults(search: p0);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    state is UpdatePriceLoadingState ||
                            state is DeleteItemLoadingState ||
                            state is GetInventorySearchResultssLoadingState
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ProductSearchItem(
                                productID: CanteenCubit.get(context)
                                    .inventorySearchResults
                                    .keys
                                    .toList()[index],
                                product: CanteenCubit.get(context)
                                    .inventorySearchResults
                                    .values
                                    .toList()[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: CanteenCubit.get(context)
                                .inventorySearchResults
                                .length)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
