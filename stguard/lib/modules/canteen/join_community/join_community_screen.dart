import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/modules/canteen/pick_school/pick_school_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CanteenJoinCommunityScreen extends StatelessWidget {
 const CanteenJoinCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {
          if (state is GetCountriesSucessState) {
            showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 30,
                            height: 5,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: defaultColor.withOpacity(0.8),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Pick your country',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Expanded(


                      flex: 5,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => CountryItem(
                                country: CanteenCubit.get(context)
                                    .countries[index]
                                    .name,
                                onTap: () => CanteenCubit.get(context)
                                    .pickCountry(index),
                              ),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount:
                              CanteenCubit.get(context).countries.length),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetSchoolsSucessState) {
            navigateTo(context, CanteenPickSchoolScreen());
          } else if (state is PickCountryState) {
            CanteenCubit.get(context).getSchools();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Image(
                    image: AssetImage('assets/images/canteen.png'),
                    width: 250,
                    color: defaultColor,
                  ),
                ),
                Text(
                  'Join your school community now',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 30,
                ),
                
                Expanded(
                  flex: 1,
                  child: DefaultButton(
                    text: 'JOIN',
                    onPressed: () {
                      CanteenCubit.get(context).getCountries();
                    },
                    color: defaultColor.withOpacity(0.8),
                    
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
