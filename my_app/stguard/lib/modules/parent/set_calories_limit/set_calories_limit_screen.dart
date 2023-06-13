import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class CaloriesLimitScreen extends StatelessWidget {
  CaloriesLimitScreen({super.key, required this.stId});
  String stId;
  TextEditingController calorieController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Calorie Limit',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(60.0),
                      child: Image(
                        image: AssetImage('assets/images/burn.png'),
                        color: defaultColor,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Text(
                      'Set a realistic calorie limit for your child based on their age, gender, height, weight, and activity level. Consult with a doctor if needed',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(
                      height: 30,
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
                        label: 'Calorie Limit'),
                    const SizedBox(
                      height: 30,
                    ),
                    DefaultButton(
                      text: 'Update',
                      showCircularProgressIndicator:
                          State is UpdateCalorieLoadingState,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          double calorieLimit =
                              double.parse(calorieController.text);
                          if (calorieLimit < 100 || calorieLimit > 4000) {
                            ShowToast(
                                message: 'Set a Realistic Calorie Limit',
                                state: ToastStates.WARNING);
                          } else {
                            ParentCubit.get(context)
                                .updateCalorie(id: stId, value: calorieLimit);
                          }
                        }
                      },
                    )
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
