import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class AllergensScreen extends StatelessWidget {
  List<String> allergens = [
    'Dairy',
    'Eggs',
    'Peanut',
    'Soy',
    'Wheat',
    'Diabetic'
  ];
  String student_id;
  AllergensScreen({super.key, required this.student_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: const PreferredSize(
              preferredSize: Size(0.5, 0.5), child: Divider()),
          title: const Text('Allergens'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            onPressed: () {
              ParentCubit.get(context).changeAllergiesSelectionState();
              Navigator.pop(context);
              ParentCubit.get(context).resetSelectedAllergies();
            },
            icon: const ImageIcon(
              AssetImage('assets/images/x.png'),
              size: 20,
              color: defaultColor,
            ),
          )),
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {
          if (state is UpdateAllergiesSuccessState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Image(
                  image: AssetImage('assets/images/blood-drop.png'),
                  width: 150,
                  height: 150,
                  color: defaultColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Please select any of the following to which your child may be allergic',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1 / 1.1,
                  //childAspectRatio: 1 / 1.72,
                  children: List.generate(
                      allergens.length,
                      (index) => AllergenSelectionItem(
                            icon: allergens[index],
                          )),
                ),
                const SizedBox(
                  height: 30,
                ),
                DefaultButton(
                        onPressed: () async {
                          ParentCubit.get(context)
                              .changeAllergiesSelectionState(state: true);
                          await ParentCubit.get(context)
                              .updateAllergens(student_id);
                        },
                        showCircularProgressIndicator: state is UpdateAllergiesLoadingState,
                        text: 'Confirm',
                        height: 55,
                        color: defaultColor.withOpacity(0.8),
                        width: double.infinity,
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
