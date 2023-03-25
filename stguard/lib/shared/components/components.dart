import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/models/canteen_product_model.dart';
import 'package:st_tracker/models/school_model.dart';
import 'package:st_tracker/models/student_attendance.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/models/product_model.dart';
import 'package:st_tracker/modules/parent/allergens/allergens_screen.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/modules/parent/attendance_history/attendance_history_screen.dart';
import 'package:st_tracker/modules/parent/member_settings/member_settings.dart';
import 'package:st_tracker/modules/parent/transaction_details/transaction_details_screen.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class DefaultButton extends StatelessWidget {
  double? width;
  double? height;
  Color? color;
  double? radius;
  String text;
  Color? textColor;
  double? textSize;
  void Function()? onPressed;
  DefaultButton(
      {this.width = double.infinity,
      this.height = 55,
      this.color = defaultColor,
      this.radius = 10,
      required this.text,
      this.textColor = Colors.white,
      this.textSize = 20,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration:
            BoxDecoration(borderRadius: BorderRadiusDirectional.circular(10)),
        child: Card(
          color: color,
          child: MaterialButton(
            onPressed: onPressed,
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: textSize),
            ),
          ),
        ));
  }
}

class DefaultFormField extends StatelessWidget {
  TextEditingController controller;
  TextInputType type;
  void Function(String)? onSubmit;
  void Function(String)? onChange;
  void Function()? onTap;
  bool isPassword;
  String? Function(String? value) validate;
  String? label;
  String? errorText;
  IconData? prefix;
  IconData? suffix;
  void Function()? changeObscured;
  bool isClickable;
  bool readOnly;
  DefaultFormField(
      {required this.controller,
      required this.type,
      this.onSubmit,
      this.onChange,
      this.errorText,
      this.onTap,
      this.isPassword = false,
      required this.validate,
      required this.label,
      this.prefix,
      IconData? this.suffix,
      this.changeObscured,
      this.isClickable = true,
      this.readOnly = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
            labelText: label,
            errorText: errorText,
            border: const OutlineInputBorder(),
            prefixIcon: Icon(prefix),
            suffixIcon: suffix != null
                ? IconButton(icon: Icon(suffix), onPressed: changeObscured)
                : null),
        validator: validate,
      ),
    );
  }
}

class DefaultRadioListTile extends StatelessWidget {
  String value;
  String? groupValue;
  void Function(String?)? onChanged;
  String title;
  DefaultRadioListTile(
      {super.key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadiusDirectional.circular(50),
      child: SizedBox(
        width: 130,
        child: RadioListTile<String>(
          activeColor: defaultColor,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
          title: Text(title),
        ),
      ),
    );
  }
}

void navigateTo(context, Widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder: ((context) => Widget)), (route) => false);

void ShowToast({required String message, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates State) {
  switch (State) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.WARNING:
      return Colors.amber;
    case ToastStates.ERROR:
      return Colors.red;
  }
}

void signOut(BuildContext context) {
  CacheHelper.removeData(key: 'id');
  CacheHelper.removeData(key: 'role');
  cancelListeners();
  FlutterBackgroundService().invoke('stopService');
  navigateAndFinish(context, LoginScreen());
}

void cancelListeners() {
  if (transListeners.isNotEmpty) {
    transListeners.forEach((key, value) {
      //value.cancel();
      transListeners[key]!.cancel();
      print('transaction listener is cancelled');
    });
    transListeners = {};
  }

  if (attendListeners.isNotEmpty) {
    attendListeners.forEach((key, value) {
      //value.cancel();
      attendListeners[key]!.cancel();
      print('attendance listener is cancelled');
    });
    attendListeners = {};
  }
}

class UserInfo extends StatelessWidget {
  dynamic userModel;
  UserInfo({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: Theme.of(context).textTheme.headline4),
        const SizedBox(
          height: 10,
        ),
        const Text('Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 5,
        ),
        Text(userModel.name,
            style: const TextStyle(fontSize: 15, color: Colors.grey)),
        const SizedBox(
          height: 10,
        ),
        const Text('Email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(
          height: 5,
        ),
        Text(userModel.email,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ))
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  dynamic? icon;
  String text;
  void Function()? ontap;
  DrawerItem({required this.text, this.icon, this.ontap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      highlightColor: defaultColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (icon is IconData)
            Icon(
              icon,
              size: 20,
            )
          else
            icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  ActivityModel model;
  List<StudentModel?> studentsData;
  ActivityItem({required this.model, required this.studentsData, super.key});

  @override
  Widget build(BuildContext context) {
    String? name;
    studentsData.forEach(
      (element) {
        if (model.st_id == element!.id) {
          name = element.name!.split(' ')[0];
        }
      },
    );
    return InkWell(
      onTap: () => model.trans_id != 'null'
          ? navigateTo(
              context,
              TransactionDetailsScreen(
                trans: model,
              ))
          : navigateTo(
              context,
              AttendanceHistoryScreen(
                model: model,
              )),
      child: SizedBox(
          height: 90,
          width: double.infinity,
          child: Card(
              elevation: 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                child: Row(
                  children: [
                    Stack(
                      alignment: model.trans_id != 'null'
                          ? AlignmentDirectional.centerStart
                          : AlignmentDirectional.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[50],
                        ),
                        Image(
                          color: defaultColor,
                          image: model.trans_id != 'null'
                              ? const AssetImage(
                                  'assets/images/shopping-cart.png')
                              : const AssetImage('assets/images/movement.png'),
                          width: 45,
                          height: 35,
                          fit: BoxFit.scaleDown,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              model.trans_id != 'null'
                                  ? '$name Puchased'
                                  : '$name ${model.activity}',
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(getDate(model.date))
                          ]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    model.trans_id != 'null'
                        ? Container(
                            alignment: AlignmentDirectional.center,
                            width: 60,
                            child: Text(
                              '-${model.activity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        : Container(
                            alignment: AlignmentDirectional.center,
                            width: 60,
                            child: Row(
                              children: [
                                model.activity == 'Arrived'
                                    ? const SizedBox(
                                        width: 10,
                                      )
                                    : const SizedBox(
                                        width: 20,
                                      ),
                                ImageIcon(
                                    size: 30,
                                    color: model.activity == 'Arrived'
                                        ? Colors.green
                                        : Colors.red,
                                    AssetImage(
                                        'assets/images/${model.activity}.png')),
                              ],
                            ),
                          )
                  ],
                ),
              ))),
    );
    ;
  }
}

class FamilyMemberCard extends StatelessWidget {
  StudentModel? model;
  bool isErrorOccured = false;
  FamilyMemberCard(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ParentCubit.get(context).getSettingsData(model!).then((value) {
          navigateTo(context, MemberSettingsScreen(student: model));
        });
      },
      child: Container(
        padding: EdgeInsets.zero,
        height: 140,
        width: 130,
        child: Card(
          elevation: 2,
          child: SizedBox(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 41,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage:!isErrorOccured? NetworkImage(model!.image!):const AssetImage('assets/images/no-image.png') as ImageProvider<Object>?,
                      onBackgroundImageError: (exception, stackTrace) {
                        isErrorOccured = true;
                      },
                   
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 80,
                      child: Center(
                          child: Text(
                        model!.name!.split(' ')[0],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )))
                ]),
          ),
        ),
      ),
    );
  }
}

String getDate(date, {format = 'EE, hh:mm a'}) {
  if (date is String) {
    return DateFormat(format).format(DateTime.parse(date));
  } else if (date is Timestamp) {
    return DateFormat(format).format(date.toDate());
  } else {
    return DateFormat(format).format(date);
  }
}

class ProductItem extends StatelessWidget {
  ProductModel product;
  ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 4,
        child: Text(
          product.productName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(
        width: 60,
      ),
      Expanded(
        flex: 2,
        child: Text(
          product.price,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      const SizedBox(
        width: 20,
      ),
      Expanded(
        flex: 2,
        child: Text(
          product.quantity.toString(),
          style: const TextStyle(fontSize: 15),
        ),
      )
    ]);
  }
}

class AttendanceHistoryItem extends StatelessWidget {
  ActivityModel model;
  AttendanceHistoryItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getDate(model.date, format: 'EEEE'),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(getDate(model.date, format: 'dd/MM/yyyy'),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
              VerticalDivider(
                color: Theme.of(context).primaryColor,
                thickness: 0.5,
              ),
              const SizedBox(width: 25),
              Expanded(child: Text(getDate(model.date, format: 'hh:mm a'))),
              SizedBox(
                width: 50,
                child: Row(
                  children: [
                    model.activity == 'Arrived'
                        ? const SizedBox(width: 10)
                        : const SizedBox(width: 20),
                    ImageIcon(AssetImage('assets/images/${model.activity}.png'),
                        color: model.activity == 'Arrived'
                            ? Colors.green
                            : Colors.red),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  List<Widget> children = const <Widget>[];
  double? card_width;
  double? card_height;
  bool condition;
  SettingsCard(
      {super.key,
      required this.children,
      required this.condition,
      this.card_width,
      this.card_height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
      width: card_width,
      height: card_height,
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: condition
              ? Column(
                  children: children,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class SliderBuilder extends StatelessWidget {
  SliderBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SliderSideLabel(
            value: 0,
            type: 'min',
          ),
          SliderTheme(
            data: const SliderThemeData(trackHeight: 3),
            child: Expanded(
              child: Slider(
                value: ParentCubit.get(context).pocket_money,
                min: 0,
                max: 500,
                label: '${ParentCubit.get(context).pocket_money}',
                divisions: 500 ~/ 5,
                onChanged: (value) {
                  if (value <= ParentCubit.get(context).parent!.balance) {
                    ParentCubit.get(context).setPocketMoney(money: value);
                  }
                },
                onChangeStart: (value) {
                  ParentCubit.get(context).showBottomSheet();
                },
              ),
            ),
          ),
          SliderSideLabel(
            value: 500,
            type: 'max',
          )
        ],
      ),
    );
  }
}

class SliderSideLabel extends StatelessWidget {
  var value;
  var type;
  SliderSideLabel({super.key, required this.value, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: type == 'min'
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        width: 35,
        child: Text(
          '${value.round()}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ));
  }
}

class CountryItem extends StatelessWidget {
  String country;
  void Function()? onTap;
  CountryItem({super.key, required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              Text(
                country,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              Icon(
                size: 20,
                Icons.arrow_forward_ios,
                color: defaultColor.withOpacity(0.8),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SchoolItem extends StatelessWidget {
  School school;
  void Function()? onTap;
  SchoolItem({super.key, required this.school, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(60)),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: Image(image: NetworkImage(school.logo)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              school.name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.arrow_forward_ios,
            color: defaultColor,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class AllergenItem extends StatelessWidget {
  dynamic icon;
  double width;
  double height;
  var id;
  BuildContext context;
  AllergenItem(
      {super.key,
      required this.icon,
      required this.id,
      required this.context,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
          child: icon is String
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image:
                        AssetImage('assets/images/${icon.toLowerCase()}.png'),
                    width: width * 0.05,
                    color: defaultColor,
                    height: height * 0.05,
                    fit: BoxFit.scaleDown,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    navigateTo(
                        context,
                        AllergensScreen(
                          student_id: id,
                        ));
                  },
                  icon: Icon(
                    icon,
                    color: defaultColor,
                  ))),
    );
  }
}

class AllergenSelectionItem extends StatelessWidget {
  dynamic icon;
  AllergenSelectionItem({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (ParentCubit.get(context).selectedAllergies.contains(icon)) {
          ParentCubit.get(context).removeAllergen(icon);
        } else {
          ParentCubit.get(context).addAllergen(icon);
        }
        print(ParentCubit.get(context).selectedAllergies);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10),
            border: Border.all(
                width: 3,
                color: ParentCubit.get(context).selectedAllergies.contains(icon)
                    ? defaultColor
                    : Theme.of(context).scaffoldBackgroundColor)),
        width: 30,
        height: 50,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/${icon.toLowerCase()}.png'),
                  width: 50,
                  color: defaultColor,
                  height: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '$icon',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class LoadingOnWaiting extends StatelessWidget {
  double height;
  double? width;
  Color? color;
  double? radius;
  LoadingOnWaiting(
      {super.key,
      this.color = defaultColor,
      this.height = 55,
      this.radius = 10,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.8),
            borderRadius: BorderRadiusDirectional.circular(10)),
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        )));
  }
}

class GradeItem extends StatelessWidget {
  String grade;
  GradeItem({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => TeacherCubit.get(context).selectGrade(grade),
      child: Container(
        alignment: AlignmentDirectional.center,
        width: 50,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(
                color: TeacherCubit.get(context).selectedGrade == grade
                    ? defaultColor.withOpacity(0.8)
                    : Colors.grey),
            borderRadius: BorderRadiusDirectional.circular(5)),
        child: Text(grade),
      ),
    );
  }
}

class StudentAttendanceCard extends StatelessWidget {
  StudentModel student;

  StudentAttendanceCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(5),
            border: Border.all(
                width: 3,
                color: TeacherCubit.get(context).attendance[student.id] != null
                    ? TeacherCubit.get(context)
                                .attendance[student.id]
                                .isPresent ==
                            1
                        ? defaultColor.withOpacity(0.8)
                        : Colors.red.withOpacity(0.8)
                    : Theme.of(context).scaffoldBackgroundColor)),
        width: double.infinity,
        height: 120,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(student.image!),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 220,
                      child: Text(
                        student.name!,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DefaultButton(
                        text: 'Present',
                        color: defaultColor.withOpacity(0.8),
                        width: 110,
                        height: 40,
                        onPressed: () {
                          TeacherCubit.get(context)
                              .addtoAttendance(student.id, student.name!, 1);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DefaultButton(
                        text: 'Absent',
                        color: Colors.red.withOpacity(0.8),
                        width: 110,
                        height: 40,
                        onPressed: () {
                          TeacherCubit.get(context)
                              .addtoAttendance(student.id, student.name!, 0);
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        )));
  }
}

class LessonCard extends StatelessWidget {
  LessonModel lesson;
  void Function() onTap;

  LessonCard({required this.lesson, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 90,
        child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          '${lesson.name.substring(0, 1).toUpperCase()}${lesson.name.substring(1)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(lesson.grade,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                              getDate(lesson.datetime,
                                  format: 'MMM, EE, hh:mm a'),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class AttendanceDetailsCard extends StatelessWidget {
  StudentAttendanceModel studentDetails;

  AttendanceDetailsCard({required this.studentDetails, super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            SizedBox(
                width: 250,
                child: Text(
                  studentDetails.studentName,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                )),
            const SizedBox(
              width: 20,
            ),
            ImageIcon(
              color: studentDetails.isPresent == 1
                  ? defaultColor.withOpacity(0.8)
                  : Colors.red.withOpacity(0.8),
              AssetImage(studentDetails.isPresent == 1
                  ? 'assets/images/check-mark.png'
                  : 'assets/images/close.png'),
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}

Future<void> requestWritePermission() async {
  if (Platform.isAndroid) {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request().then((value) {
        if (value.isDenied) {
          print("Permission to write to external storage denied");
        } else if (value.isGranted) {
          print("Permission to write to external storage granted");
        }
        return value;
      });
    }
  }
}

class CanteenProductCard extends StatelessWidget {
  CanteenProductModel product;
  String productID;
  void Function()? onTap;
  CanteenProductCard(
      {super.key, required this.productID, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.network(
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  product.image,
                  errorBuilder: (context, error, stackTrace) => const Image(
                      fit: BoxFit.contain,
                      width: 120,
                      height: 120,
                      image: AssetImage('assets/images/no-image.png'))),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SizedBox(
                        width: 65,
                        child: Text(
                          '${product.price.toStringAsFixed(2)} EGP',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ImageIcon(
                          color: CanteenCubit.get(context)
                                  .selectedProducts
                                  .keys
                                  .contains(productID)
                              ? defaultColor
                              : Colors.black,
                          const AssetImage('assets/images/shopping-cart.png'))
                    ],
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

class ProductSearchItem extends StatelessWidget {
  CanteenProductModel product;
  void Function()? ontap;
  var priceController = TextEditingController();
  String productID;
  ProductSearchItem({
    super.key,
    this.ontap,
    required this.productID,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  product.image,
                  errorBuilder: (context, error, stackTrace) => const Image(
                      fit: BoxFit.contain,
                      width: 50,
                      height: 50,
                      image: AssetImage('assets/images/no-image.png'))),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${product.price.toStringAsFixed(2)} EGP',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: defaultColor.withOpacity(0.8),
                    ),
                    onPressed: () async {
                      await showDefaultDialog(context,
                          content: DefaultFormField(
                              controller: priceController,
                              type: TextInputType.number,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Price must not be empty';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              label: 'New Price'),
                          title: 'Update Price',
                          buttonText1: 'Cancel',
                          buttonText2: 'Update', onPressed1: () {
                        Navigator.pop(context);
                      }, onPressed2: () {
                        CanteenCubit.get(context).updatePrice(
                            id: productID,
                            newPrice: double.parse(priceController.text),
                            category: product.category);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: defaultColor.withOpacity(0.8),
                    ),
                    onPressed: () async {
                      await showDefaultDialog(context,
                          title: 'Delete Item',
                          content: const Text(
                              'Are you sure you want to delete this item?'),
                          buttonText1: 'Cancel',
                          onPressed1: () => Navigator.pop(context),
                          buttonText2: 'Delete',
                          onPressed2: () => CanteenCubit.get(context)
                              .deleteItem(
                                  id: productID, category: product.category));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCartItem extends StatelessWidget {
  CanteenProductModel product;
  String productID;
  Widget suffixWidget;
  ProductCartItem(
      {super.key,
      required this.productID,
      required this.product,
      required this.suffixWidget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  product.image,
                  errorBuilder: (context, error, stackTrace) => const Image(
                      fit: BoxFit.contain,
                      width: 50,
                      height: 50,
                      image: AssetImage('assets/images/no-image.png'))),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${product.price.toStringAsFixed(2)} EGP',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              suffixWidget
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryCategoryCard extends StatelessWidget {
  String? category;
  void Function()? onPressed;
  InventoryCategoryCard({super.key, required this.category, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(category!),
          const SizedBox(
            width: 5,
          ),
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.delete,
                color: defaultColor.withOpacity(0.8),
              ),
              padding: EdgeInsets.zero)
        ],
      ),
    ));
  }
}

class SearchTextFormField extends StatelessWidget {
  TextEditingController searchController;
  void Function(String)? onChanged;
  SearchTextFormField(
      {super.key, required this.searchController, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
              onPressed: () async {
                searchController.clear();
                await CanteenCubit.get(context).getProducts();
              },
              icon: const Icon(Icons.clear)),
          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          hintText: 'Search...'),
      controller: searchController,
      keyboardType: TextInputType.text,
      validator: (value) {
        return null;
      },
      onChanged: onChanged,
    );
  }
}

Future<Widget?> showDefaultDialog(context,
    {Widget? content,
    required String title,
    required String buttonText1,
    required void Function()? onPressed1,
    required String buttonText2,
    required void Function()? onPressed2}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: onPressed1,
          child: Text(buttonText1),
        ),
        ElevatedButton(
          onPressed: onPressed2,
          child: Text(buttonText2),
        )
      ],
    ),
  );
}
