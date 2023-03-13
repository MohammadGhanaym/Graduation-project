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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 30,
                            height: 5,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: defaultColor.withOpacity(0.8),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Pick your country',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
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
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount:
                              CanteenCubit.get(context).countries.length),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetSchoolsSucessState) {
            navigateTo(context, const CanteenPickSchoolScreen());
          } else if (state is PickCountryState) {
            CanteenCubit.get(context).getSchools();
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                              Expanded(
                                flex: 5,
                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(right: 20, left: 20, top: 100),
                                                  alignment: AlignmentDirectional.center,
                                                  height: 400,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(
                                                          bottomLeft: Radius.circular(30),
                                                          bottomRight: Radius.circular(30)),
                                                      color: Theme.of(context).primaryColor),
                                              child: Column(
                                                children: [
                                                  Image(
                                                    image: AssetImage('assets/images/canteen.png'),
                                                    width: 250,
                                                    height: 250,
                                                    color: Colors.white,
                                                  ),SizedBox(
                                                    height: 40,
                                                  ),
                                                  Text(
                                                    
                                                    'Join your school community now and be a part of the team',
                                                    style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                              ),
            
            
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DefaultButton(
                      height: 55,
                      text: 'JOIN',
                      onPressed: () {
                        CanteenCubit.get(context).getCountries();
                      },
                      color: defaultColor.withOpacity(0.8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
