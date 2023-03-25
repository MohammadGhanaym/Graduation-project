import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class MemberSettingsScreen extends StatelessWidget {
  StudentModel? student;
  MemberSettingsScreen({required this.student, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentCubit, ParentStates>(
      listener: (context, state) {
        if (state is UnpairDigitalIDSuccess) {
          navigateAndFinish(context, ParentHomeScreen());
          ParentCubit.get(context).showSettings();
          ParentCubit.get(context).changeSettingsVisibility();
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  ParentCubit.get(context).hideBottomSheet();
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ),
              ),
              title: Text("${student!.name!.split(' ')[0]}'s settings"),
            ),
            bottomSheet: ParentCubit.get(context).isBottomSheetShown
                ? BottomSheet(
                    onClosing: () {},
                    builder: (context) => Container(
                        color: defaultColor.withOpacity(0.8),
                        width: double.infinity,
                        child: MaterialButton(
                            onPressed: () async {
                              await ParentCubit.get(context)
                                  .updatePocketMoney(id: student!.id);
                            },
                            child: const Text('Give',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))))
                : null,
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: state is GetDigitalIDStateLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(10))),
                          width: double.infinity,
                          height: 120,
                          child: Card(
                            color: ParentCubit.get(context).isPaired &&
                                    ParentCubit.get(context)
                                        .studentsPaths
                                        .keys
                                        .contains(student!.id) &&
                                    ParentCubit.get(context).active != null
                                ? defaultColor
                                : Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 10, bottom: 10, right: 10),
                              child: Column(
                                children: [
                                  Row(
                                    textBaseline: TextBaseline.alphabetic,
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    children: [
                                      const SizedBox(
                                          width: 160,
                                          child: Text(
                                            'Digital ID Number',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text('${student!.id}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white54)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 180,
                                          child: Text(
                                            ParentCubit.get(context).isPaired &&
                                                    ParentCubit.get(context)
                                                        .studentsPaths
                                                        .keys
                                                        .contains(
                                                            student!.id) &&
                                                    ParentCubit.get(context)
                                                            .active !=
                                                        null
                                                ? 'Activated'
                                                : 'Deactivated',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )),
                                      const SizedBox(
                                        width: 50,
                                      ),
                                      Switch(
                                        activeColor: defaultColor.shade700,
                                        activeTrackColor: defaultColor.shade100,
                                        value: ParentCubit.get(context)
                                                .isPaired &&
                                            ParentCubit.get(context)
                                                .studentsPaths
                                                .keys
                                                .contains(student!.id) &&
                                            ParentCubit.get(context).active !=
                                                null,
                                        onChanged: (value) async {
                                          await ParentCubit.get(context)
                                              .changeDigitalIDState(
                                                  student!.id);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: ParentCubit.get(context).settingsVisibility,
                          maintainState: true,
                          maintainAnimation: true,
                          child: AnimatedOpacity(
                            opacity: (ParentCubit.get(context).isPaired &&
                                    ParentCubit.get(context)
                                        .studentsPaths
                                        .keys
                                        .contains(student!.id))
                                ? 1
                                : 0.0,
                            onEnd: () => ParentCubit.get(context)
                                .changeSettingsVisibility(),
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                // location
                                SettingsCard(
                                  condition:
                                      state is! GetStudentLocationLoadingState,
                                  card_width: double.infinity,
                                  card_height: 120,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Image(
                                            width: 30,
                                            height: 30,
                                            image: AssetImage(
                                                'assets/images/map.png')),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            const Text(
                                              'Location',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text(
                                              'Last Seen',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              ParentCubit.get(context)
                                                          .location !=
                                                      null
                                                  ? ParentCubit.get(context)
                                                      .location!
                                                      .time
                                                  : '',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 190,
                                      height: 40,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            ParentCubit.get(context).openMap(
                                                lat: ParentCubit.get(context)
                                                    .location!
                                                    .lat,
                                                long: ParentCubit.get(context)
                                                    .location!
                                                    .long),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Find ${student!.name!.split(' ')[0]}',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: defaultColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SettingsCard(
                                    condition:
                                        state is! GetPocketMoneyLoadingState,
                                    card_width: double.infinity,
                                    card_height: 120,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const ImageIcon(
                                            AssetImage(
                                                'assets/images/pocket_money.png'),
                                            size: 30,
                                            color: defaultColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            'Spending Limits',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            alignment:
                                                AlignmentDirectional.center,
                                            width: 60,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: defaultColor,
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(15)),
                                            child: Text(
                                              '${ParentCubit.get(context).pocket_money.toInt()} EGP',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SliderBuilder()
                                    ]),
                                const SizedBox(
                                  height: 10,
                                ),
                                SettingsCard(
                                    condition:
                                        state is! GetAllergiesLoadingState,
                                    card_width: double.infinity,
                                    card_height: 180,
                                    children: [
                                      Row(
                                        children: [
                                          const ImageIcon(
                                            AssetImage(
                                                'assets/images/blood-drop.png'),
                                            size: 30,
                                            color: defaultColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            'Allergens',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'By adding allergens, your child will not be able to purchase anything that marked by a vendor containing them',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Expanded(
                                          child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) =>
                                                  AllergenItem(
                                                      id: student!.id,
                                                      width: 65,
                                                      height: 80,
                                                      icon: ParentCubit.get(
                                                              context)
                                                          .allergies
                                                          .reversed
                                                          .toList()[index],
                                                      context: context),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(width: 5),
                                              itemCount:
                                                  ParentCubit.get(context)
                                                      .allergies
                                                      .length))
                                    ])
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        MaterialButton(
                          color: Colors.red,
                          onPressed: () {
                            ParentCubit.get(context).showSettings();
                            showDefaultDialog(
                              context,
                              title: 'Are you sure?',
                              content: const Text(
                                  'If you deactivated your digital ID, you will not able to use it to spend and load up your account'),
                              buttonText1: "CANCEL",
                              buttonText2: "YES, I'M SURE",
                              onPressed1: () {
                                ParentCubit.get(context).showSettings();

                                Navigator.of(context).pop();
                              },
                              onPressed2: () async {
                                await ParentCubit.get(context)
                                    .unpairDigitalID(student!.id);
                              },
                            );
                          },
                          child: const Text(
                            'Unpair Digital ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
            ));
      },
    );
  }
}
