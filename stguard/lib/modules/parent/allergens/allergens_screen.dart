import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AllergensScreen extends StatelessWidget {
  List<String> allergens = [
    'Dairy',
    'Eggs',
    'Peanut',
    'Soy',
    'Wheat',
    'Diabetic'
  ];
  var student_id;
  AllergensScreen({super.key, required this.student_id});

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
                bottom: PreferredSize(child: Divider(), preferredSize: Size(0.5, 0.5)),

          title: Text('Allergens'),
          titleSpacing: screen_width * 0.25,
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: ImageIcon(
              AssetImage('assets/images/x.png'),
              size: 20,
              color: defaultColor,
            ),
          )),
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                
                SizedBox(
                  height: screen_height * 0.01,
                ),
                Image(
                  image: AssetImage('assets/images/blood-drop.png'),
                  width: screen_width * 0.4,
                  height: screen_width * 0.4,
                  color: defaultColor,
                ),
                SizedBox(
                  height: screen_height * 0.05,
                ),
                Text(
                  'Please select any of the following to which your child may be allergic.',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screen_height * 0.05),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 1 / 1.1,
                  //childAspectRatio: 1 / 1.72,
                  children: List.generate(
                      allergens.length,
                      (index) => AllergenSelectionItem(
                          icon: allergens[index],
                          context: context,
                          width: screen_width,
                          height: screen_height)),
                ),
                SizedBox(
                  height: screen_height * 0.05,
                ),
                state is UpdateAllergiesLoadingState
                    ? LoadingOnWaiting(
                        width: screen_width * 0.7,
                        height: screen_height * 0.06,
                        color: defaultColor,
                        radius: 10,
                      )
                    : DefaultButton(
                        onPressed: () {
                          ParentCubit.get(context)
                              .updateAllergens(student_id)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        },
                        text: 'Confirm',
                        height: screen_height * 0.06,
                        width: screen_width * 0.7,
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
