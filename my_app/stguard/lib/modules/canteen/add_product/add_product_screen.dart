import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var formKeyIngredient = GlobalKey<FormState>();
  var formKeyCategory = GlobalKey<FormState>();
  
  TextEditingController priceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();
  TextEditingController calorieController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              CanteenCubit.get(context).resetItemData();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Add New Item'),
        centerTitle: true,
      ),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
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
                            height: 130,
                            width: 130,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.scaleDown,
                                image:
                                    CanteenCubit.get(context).itemImage == null
                                        ? const AssetImage(
                                            'assets/images/add_image.png')
                                        : FileImage(CanteenCubit.get(context)
                                            .itemImage!) as ImageProvider,
                              ),
                            ),
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
                              categoryController.clear();
                              String? cat = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: CanteenCubit.get(context)
                                          .categories
                                          .map((item) {
                                        if (item == 'All') {
                                          return SimpleDialogOption(
                                              child: Form(
                                            key: formKeyCategory,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 80,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 230,
                                                        child: TextFormField(
                                                          controller:
                                                              categoryController,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return 'Please enter category name';
                                                            } else if (CanteenCubit
                                                                    .get(
                                                                        context)
                                                                .categories
                                                                .contains(
                                                                    value)) {
                                                              return 'This category already exists';
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      'Add New Category',
                                                                  border:
                                                                      const OutlineInputBorder(),
                                                                  suffixIcon:
                                                                      IconButton(
                                                                          onPressed:
                                                                              (() {
                                                                            if (formKeyCategory.currentState!.validate()) {
                                                                              Navigator.pop(context);
                                                                            }
                                                                          }),
                                                                          icon:
                                                                              const Icon(Icons.add))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Divider()
                                              ],
                                            ),
                                          ));
                                        }
                                        return SimpleDialogOption(
                                          child: Text(item),
                                          onPressed: () {
                                            Navigator.pop(context, item);
                                          },
                                        );
                                      }).toList(),
                                    );
                                  });

                              if (cat != null) {
                                categoryController.text = cat;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                                               
                        DefaultFormField(
                            controller: calorieController,
                            type: TextInputType.number,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Calories must not be empty';
                              }
                               if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            label: 'Calories (kcal)'),
                        const SizedBox(height: 20),
                         Form(
                          key: formKeyIngredient,
                           child: TypeAheadFormField(
                                              textFieldConfiguration:
                                                  TextFieldConfiguration(
                                                    
                                                      controller:
                                                          ingredientController,
                                                      decoration:
                                                           InputDecoration(
                                                            
                                                            suffixIcon: IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed:() {
                                                              if (formKeyIngredient.currentState!
                                        .validate()) {
                                      CanteenCubit.get(context).addIngredient(
                                          ingredientController.text);
                                      ingredientController.clear();
                                    }
                                                            }, icon: const Icon(Icons.add)),
                                                        label: const Text(
                                                            'Ingredient'),prefixIcon: const Icon(null),
                                                        border:
                                                            const OutlineInputBorder(),
                                                      )),
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                ingredientController.text =
                                                    suggestion;
                                              },
                                              itemBuilder:
                                                  (context, itemData) {
                                                return ListTile(
                                                  title: Text(itemData),
                                                );
                                              },
                                              suggestionsCallback: (pattern) {
                                                print(pattern);
                                                return CanteenCubit.get(context)
                                                .allergens
                                                .where((suggestion) =>
                                                    suggestion.toLowerCase().contains(pattern.toLowerCase()))
                                                .toList();
                                              },
                                              validator: (value) {
                                                if (value==null 
                                                
                                                || value.isEmpty) {
                                                  return 'Please enter an ingredient name';
                                                }
                                                if (CanteenCubit.get(context)
                                                    .ingredients
                                                    .contains(value)) {
                                                  return 'You have already entered this ingredient before';
                                                }
                                                return null;
                                              },
                                            ),
                         )
                               ,
               const SizedBox(
                          height: 10,
                        ),
                         Wrap(
                                spacing: 8.0,
                                runSpacing:
                                    8.0, // sets the space between the blocks
                                children: CanteenCubit.get(context)
                                    .ingredients
                                    .map((ingredient) {
                                  return Container(
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
                                          SizedBox(
                                            width: 100,
                                            child: Text(ingredient, overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                          ,
                        const SizedBox(
                          height: 20,
                        ),
                        DefaultButton(
                              showCircularProgressIndicator: state is UploadItemDataLoadingState,
                                color: defaultColor.withOpacity(0.8),
                                text: 'Confirm',
                                onPressed: (() async {
                                  if (formKey.currentState!.validate()) {
                                    if (CanteenCubit.get(context).itemImage ==
                                        null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.white,
                                              duration: Duration(seconds: 2),
                                              content: Text(
                                                'Please pick an item image',
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 15),
                                              )));
                                    } else {
                                      await CanteenCubit.get(context)
                                          .checkAllergens(
                                        name: nameController.text,
                                        price:
                                            double.parse(priceController.text),
                                        category: categoryController.text,
                                        calories: double.parse(calorieController.text)
                                      );
                                    }
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
