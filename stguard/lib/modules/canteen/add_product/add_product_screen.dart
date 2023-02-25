import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var formKeyIngredient = GlobalKey<FormState>();
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
        centerTitle: true,
      ),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => CanteenCubit.get(context).getItemImage(),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.scaleDown,
                                  image: CanteenCubit.get(context).itemImage ==
                                          null
                                      ? const AssetImage(
                                          'assets/images/add_image.png')
                                      : FileImage(CanteenCubit.get(context)
                                          .itemImage!) as ImageProvider,
                                ),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        DefaultFormField(
                            controller: nameController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Item name must not be empty';
                              }
                              return null;
                            },
                            label: 'Name'),
                        const SizedBox(height: 20),
                        DefaultFormField(
                            controller: priceController,
                            type: TextInputType.number,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Item price must not be empty';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            label: 'Price'),
                        const SizedBox(
                          height: 20,
                        ),
                        DefaultFormField(
                            controller: categoryController,
                            type: TextInputType.text,
                            readOnly: true,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Item category must not be empty';
                              }

                              return null;
                            },
                            label: 'Category',
                            onTap: () async {
                              String? cat = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: CanteenCubit.get(context)
                                          .categories
                                          .map((item) => SimpleDialogOption(
                                                child: Text(item),
                                                onPressed: () {
                                                  Navigator.pop(context, item);
                                                },
                                              ))
                                          .toList(),
                                    );
                                  });

                              if (cat != null) {
                                categoryController.text = cat;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Ingredients',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: MaterialButton(
                                  elevation: 1,
                                  color: Colors.white,
                                  onPressed: (() {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Add ingredients'),
                                        content: Form(
                                          key: formKeyIngredient,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'Please ensure to accurately enter the ingredients for each item, as this information will be used to identify allergens for our students. Thank you for helping us provide a safe and enjoyable dining experience.',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption),
                                              const SizedBox(height: 10),
                                              DefaultFormField(
                                                  controller:
                                                      ingredientController,
                                                  type: TextInputType.text,
                                                  validate: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter an ingredient name';
                                                    }
                                                    return null;
                                                  },
                                                  label: 'Ingredient Name')
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Done'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ingredientController.clear();
                                            },
                                          ),
                                          ElevatedButton(
                                            child: const Text('Add'),
                                            onPressed: () {
                                              if (formKeyIngredient
                                                  .currentState!
                                                  .validate()) {
                                                CanteenCubit.get(context)
                                                    .addIngredient(
                                                        ingredientController
                                                            .text);
                                                ingredientController.clear();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  child: const Icon(
                                    Icons.add,
                                    color: defaultColor,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CanteenCubit.get(context).ingredients.isNotEmpty
                            ? Wrap(
                                spacing: 8.0,
                                runSpacing:
                                    8.0, // sets the space between the blocks
                                children: CanteenCubit.get(context)
                                    .ingredients
                                    .map((ingredient) {
                                  return Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: InkWell(
                                      onTap: () => CanteenCubit.get(context)
                                          .removeIngredient(ingredient),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(ingredient),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const ImageIcon(
                                              size: 10,
                                              AssetImage('assets/images/x.png'))
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : Container(
                                height: 40,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        DefaultButton(
                            color: defaultColor.withOpacity(0.8),
                            text: 'Confirm',
                            onPressed: (() async {
                              if (formKey.currentState!.validate()) {
                                await CanteenCubit.get(context).checkAllergens(
                                  name: nameController.text,
                                  price: double.parse(priceController.text),
                                  category: categoryController.text,
                                );
                              }
                            }))
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
