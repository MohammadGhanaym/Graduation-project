import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/states.dart';
import 'package:st_tracker/modules/teacher/pick_school/pick_school_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class JoinCommunityScreen extends StatelessWidget {
  String image;
  JoinCommunityScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TeacherCubit, TeacherStates>(
        listener: (context, state) {
          if (state is GetCountriesSucessState) {
            showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screen_width * 0.1,
                    vertical: screen_height * 0.02),
                child: Column(
                  children: [
                    Container(
                      width: screen_width * 0.1,
                      height: screen_height * 0.005,
                      margin: EdgeInsets.only(top: screen_height * 0.01),
                      decoration: BoxDecoration(
                          color: defaultColor.withOpacity(0.8),
                          borderRadius: BorderRadius.all(
                              Radius.circular(screen_width * 0.02))),
                    ),
                    SizedBox(
                      height: screen_height * 0.02,
                    ),
                    Text(
                      'Pick your country',
                      style: TextStyle(
                          fontSize: screen_width * 0.07,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: screen_height * 0.02,
                    ),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => CountryItem(
                                country: TeacherCubit.get(context)
                                    .countries[index]
                                    .name,
                                onTap: () => TeacherCubit.get(context)
                                    .pickCountry(index),
                              ),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount:
                              TeacherCubit.get(context).countries.length),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetSchoolsSucessState) {
            navigateTo(context, TeacherPickSchoolScreen());
          } else if (state is PickCountryState) {
            TeacherCubit.get(context).getSchools();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: screen_height * 0.05, horizontal: screen_width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(image),
                  width: screen_width * 0.6,
                  height: screen_height * 0.2,
                  color: defaultColor,
                ),SizedBox(
                  height: screen_height * 0.1,
                ),
                Text(
                  'Join your school community now and be a part of the team!',
                  style: TextStyle(
                      fontSize: screen_width * 0.1,
                      fontWeight: FontWeight.w500),
                ),
                
                
                SizedBox(
                  height: screen_height * 0.1,
                ),
                DefaultButton(
                  text: 'JOIN',
                  onPressed: () {
                    TeacherCubit.get(context).getCountries();
                  },
                  color: defaultColor.withOpacity(0.8),
                  height: screen_height * 0.06,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
