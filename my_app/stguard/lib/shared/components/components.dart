import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/models/activity_model.dart';
import 'package:stguard/models/canteen_product_model.dart';
import 'package:stguard/models/exam_results_model.dart';
import 'package:stguard/models/school_model.dart';
import 'package:stguard/models/student_attendance.dart';
import 'package:stguard/models/student_model.dart';
import 'package:stguard/modules/canteen/product_details/product_details_screen.dart';
import 'package:stguard/modules/parent/allergens/allergens_screen.dart';
import 'package:stguard/modules/parent/attendance_history/attendance_history_screen.dart';
import 'package:stguard/modules/parent/child_community/child_community.dart';
import 'package:stguard/modules/parent/note_details/note_details_screen.dart';
import 'package:stguard/modules/parent/transaction_details/transaction_details_screen.dart';
import 'package:stguard/modules/teacher/attendance_details/attendance_details_screen.dart';
import 'package:stguard/modules/teacher/exam_results_details/exam_results_details_screen.dart';
import 'package:stguard/modules/teacher/update_grade/update_grade_screen.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/styles/themes.dart';

class DefaultButton extends StatelessWidget {
  double? width;
  double? height;
  Color? color;
  double? radius;
  String text;
  Color? textColor;
  double? textSize;
  bool showCircularProgressIndicator;
  void Function()? onPressed;
  DefaultButton(
      {this.width = double.infinity,
      this.height = 55,
      this.showCircularProgressIndicator = false,
      this.color = defaultColor,
      this.radius = 10,
      required this.text,
      this.textColor = Colors.white,
      this.textSize = 20,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: !showCircularProgressIndicator,
      builder: (context) => Container(
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
                style: TextStyle(
                    color: textColor,
                    fontSize: textSize,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
      fallback: (context) => const Center(child: CircularProgressIndicator()),
    );
  }
}

class DefaultButton2 extends StatelessWidget {
  void Function()? onPressed;
  double width;
  double height;
  String text;
  double sizedboxHeight;
  TextStyle? textStyle;
  String image;
  double imageWidth;
  double imageHeight;

  DefaultButton2(
      {super.key,
      required this.width,
      required this.height,
      this.sizedboxHeight = 5,
      required this.image,
      required this.text,
      this.textStyle,
      required this.imageWidth,
      required this.imageHeight,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      color: defaultColor,
                      image: AssetImage(image),
                      width: imageWidth,
                      height: imageHeight),
                  SizedBox(
                    height: sizedboxHeight,
                  ),
                  Text(
                    text,
                    style: textStyle,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class DefaultButton3 extends StatelessWidget {
  void Function()? onPressed;
  double width;
  double height;
  String text;
  double sizedboxWidth;
  TextStyle? textStyle;
  String image;
  double imageWidth;
  double imageHeight;

  DefaultButton3(
      {super.key,
      required this.width,
      required this.height,
      this.sizedboxWidth = 5,
      required this.image,
      required this.text,
      this.textStyle,
      required this.imageWidth,
      required this.imageHeight,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      color: defaultColor,
                      image: AssetImage(image),
                      width: imageWidth,
                      height: imageHeight),
                  SizedBox(
                    width: sizedboxWidth,
                  ),
                  Text(
                    text,
                    style: textStyle,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: defaultColor,
                    size: 20,
                  ),
                ],
              ),
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
  int? maxLines;
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
      this.maxLines = 1,
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
        maxLines: maxLines,
        readOnly: readOnly,
        cursorColor: defaultColor,
        decoration: InputDecoration(
            focusColor: defaultColor,
            labelText: label,
            errorText: errorText,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: defaultColor)),
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
        Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: defaultColor),
        ),
        const SizedBox(
          height: 10,
        ),
        Text('Name',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(
          height: 5,
        ),
        Text(
          userModel.name,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 10,
        ),
        Text('Email',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(
          height: 5,
        ),
        Text(
          userModel.email,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
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
            style: Theme.of(context).textTheme.titleLarge,
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
                                  fontSize: 15,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              getDate(model.date),
                              style: Theme.of(context).textTheme.bodySmall,
                            )
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
          navigateTo(context, MemberCommunityScreen(student: model!));
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
                  Container(
                    width: 81,
                    height: 81,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: defaultColor)),
                    child: Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image(
                        image: NetworkImage(
                          model!.image!,
                        ),
                        errorBuilder: (context, error, stackTrace) =>
                            const Image(
                                image:
                                    AssetImage('assets/images/no-image.png')),
                      ),
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
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w500),
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
  dynamic product;
  ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        flex: 4,
        child: Text(
          product.name,
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
          '${product.price}',
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
  double elevation;
  bool condition;
  SettingsCard(
      {super.key,
      required this.children,
      required this.condition,
      this.elevation = 0.0,
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
        elevation: elevation,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
  dynamic max;
  double value;
  void Function(double)? onChanged;
  void Function(double)? onChangeStart;
  SliderBuilder(
      {super.key,
      required this.max,
      required this.value,
      required this.onChangeStart,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SliderSideLabel(
            value: 10,
            type: 'min',
          ),
          SliderTheme(
            data: SliderThemeData(
                trackHeight: 3,
                thumbColor: defaultColor,
                activeTrackColor: defaultColor,
                inactiveTrackColor: defaultColor.withOpacity(0.2)),
            child: Expanded(
              child: Slider(
                value: value,
                min: 10,
                max: max.toDouble(),
                label: '$value',
                divisions: max ~/ 5,
                onChanged: onChanged,
                onChangeStart: onChangeStart,
              ),
            ),
          ),
          SliderSideLabel(
            value: max,
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
        width: type == 'min'? 35: 50,
        child: Text(
          '${value.round()}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),overflow: TextOverflow.ellipsis,
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
        if (!ParentCubit.get(context).confirmAllergiesSelection) {
          if (ParentCubit.get(context).selectedAllergies.contains(icon)) {
            ParentCubit.get(context).removeAllergen(icon);
          } else {
            ParentCubit.get(context).addAllergen(icon);
          }
          print(ParentCubit.get(context).selectedAllergies);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10),
            border: Border.all(
                width: 3,
                color: ParentCubit.get(context).selectedAllergies.contains(icon)
                    ? defaultColor
                    : Theme.of(context).scaffoldBackgroundColor)),
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
                Text('$icon', style: Theme.of(context).textTheme.titleMedium)
              ],
            ),
          ),
        )),
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
                    ? TeacherCubit.get(context).attendance[student.id] == 1
                        ? defaultColor.withOpacity(0.8)
                        : Colors.red.withOpacity(0.8)
                    : Theme.of(context).scaffoldBackgroundColor)),
        width: double.infinity,
        height: 130,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                  width: 70,
                  height: 70,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(30),
                  ),
                  child: Image.network(
                    student.image!,
                    errorBuilder: (context, error, stackTrace) => const Image(
                        image: AssetImage('assets/images/no-image.png')),
                  )),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 50),
                      IconButton(
                          onPressed: () {
                            TeacherCubit.get(context)
                                .addtoAttendance(student.id, student.name!, 1);
                          },
                          icon: ImageIcon(
                              const AssetImage('assets/images/check-mark.png'),
                              color: defaultColor.withOpacity(0.8),
                              size: 40)),
                      const SizedBox(
                        width: 40,
                      ),
                      IconButton(
                          onPressed: () {
                            TeacherCubit.get(context)
                                .addtoAttendance(student.id, student.name!, 0);
                          },
                          icon: const ImageIcon(
                            AssetImage('assets/images/error.png'),
                            color: Colors.red,
                            size: 40,
                          ))
                    ],
                  )
                ],
              ),
            ],
          ),
        )));
  }
}

class AttendanceDetailsCard extends StatelessWidget {
  LessonAttendance lessonAttendance;
  StudentModel student;
  AttendanceDetailsCard(
      {required this.lessonAttendance, required this.student, super.key});
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
                  student.name!,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                )),
            const SizedBox(
              width: 20,
            ),
            if (lessonAttendance.attendance.containsKey(student.id))
              ImageIcon(
                color: lessonAttendance.attendance[student.id] == 1
                    ? defaultColor.withOpacity(0.8)
                    : Colors.red.withOpacity(0.8),
                AssetImage(lessonAttendance.attendance[student.id] == 1
                    ? 'assets/images/check-mark.png'
                    : 'assets/images/error.png'),
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
      onLongPress: () {
        navigateTo(context, ProductDetailsScreen(product: product));
      },
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
                          currencyFormat(product.price),
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
                    icon: const ImageIcon(
                      AssetImage('assets/images/edit.png'),
                      color: defaultColor,
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
                    icon: const ImageIcon(
                        AssetImage('assets/images/delete.png'),
                        color: defaultColor),
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
                                  id: productID,
                                  category: product.category,
                                  image: product.image));
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
              icon: const ImageIcon(AssetImage('assets/images/delete.png'),
                  color: defaultColor),
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
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: onPressed1,
          child: Text(
            buttonText1,
            style: const TextStyle(color: defaultColor),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => defaultColor)),
          onPressed: onPressed2,
          child: Text(buttonText2),
        )
      ],
    ),
  );
}

class FileItem extends StatelessWidget {
  String fileName;
  void Function()? onPressed;
  String? progress;
  FileItem(
      {super.key,
      required this.fileName,
      required this.onPressed,
      this.progress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(fileName),
      subtitle: progress != null ? Text(progress!) : null,
      trailing: IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: onPressed,
      ),
    );
  }
}

class ParentAttendanceItem extends StatelessWidget {
  StudentModel st;
  final LessonAttendance attendanceDetails;
  ParentAttendanceItem({required this.attendanceDetails, required this.st});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attendanceDetails.lessonName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    attendanceDetails.subject,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  getDate(attendanceDetails.datetime, format: 'MMM dd, hh:mm a'),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  AssetImage(attendanceDetails.attendance.containsKey(st.id)
                      ? attendanceDetails.attendance[st.id] == 1
                          ? 'assets/images/check-mark.png'
                          : 'assets/images/error.png'
                      : 'assets/images/error.png'),
                  size: 40,
                  color: attendanceDetails.attendance.containsKey(st.id)
                      ? attendanceDetails.attendance[st.id] == 1
                          ? defaultColor
                          : Colors.red
                      : Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// write your code here
//-------------------------

class ParentGradeItem extends StatelessWidget {
  ExamResults result;
  String st;
  ParentGradeItem({required this.result, required this.st});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.examType,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    result.subject,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Spacer(),
                Text(
                  getDate(result.datetime, format:'MMM dd, hh:mm a'),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
            const SizedBox(height: 10),
            result.grades.containsKey(st)
                ? result.grades[st].runtimeType != String
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          LinearPercentIndicator(
                            barRadius: const Radius.circular(10),
                            trailing: Text('${result.maximumAchievableGrade}'),
                            lineHeight: 20.0,
                            percent: result.grades[st] /
                                result.maximumAchievableGrade,
                            backgroundColor: defaultColor.withOpacity(0.2),
                            progressColor: defaultColor,
                            center: Text(
                              '${result.grades[st]}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : Text('N/A',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontSize: 18))
                : Text('N/A',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 18))
          ],
        ),
      ),
    );
  }
}

class DefaultClassListCard extends StatelessWidget {
  final void Function()? onTap;
  void Function()? teacherOnTap;
  String title;
  String subtitle;
  DateTime date;
  DefaultClassListCard(
      {required this.onTap,
      required this.title,
      required this.subtitle,
      required this.date,
      this.teacherOnTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  if (teacherOnTap != null)
                    const SizedBox(
                      width: 20,
                    ),
                  if (teacherOnTap != null) const Spacer(),
                  if (teacherOnTap != null)
                    IconButton(
                        onPressed: teacherOnTap,
                        icon: const ImageIcon(
                            AssetImage('assets/images/delete_note.png'),
                            color: defaultColor)),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    getDate(date, format: 'EE, hh:mm a'),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParentFileItem extends StatelessWidget {
  final String name;
  final String url;

  ParentFileItem({required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16.0),
        ),
        InkWell(
          child: Text(
            url,
            style: const TextStyle(fontSize: 14.0, color: Colors.blue),
          ),
          onTap: () {
            ParentCubit.get(context).downloadFile(fileName: name, fileUrl: url);
          },
        ),
        const Divider(),
      ],
    );
  }
}

class DownloadItem extends StatelessWidget {
  final String fileName;
  final String fileUrl;
  final bool fileExists;

  DownloadItem({
    required this.fileName,
    required this.fileUrl,
    required this.fileExists,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (fileExists) {
                ParentCubit.get(context).openDownloadedFile(fileName);
              } else {
                ParentCubit.get(context)
                    .downloadFile(fileName: fileName, fileUrl: fileUrl);
              }
            },
            child: SizedBox(
              width: 250,
              child: Row(
                children: [
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: ParentCubit.get(context)
                            .downloadFilesInfo
                            .keys
                            .contains(fileName)
                        ? CircularProgressIndicator(
                            value: ParentCubit.get(context)
                                .downloadFilesInfo[fileName]!
                                .progress,
                          )
                        : Icon(
                            Icons.download_rounded,
                            color: fileExists ? defaultColor : null,
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (fileExists)
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => ParentCubit.get(context).deleteFile(fileName),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ))
        ],
      ),
    );
  }
}

void showSnackBar(BuildContext context,
    {required String message, required IconData icon}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
    children: [
      Icon(
        icon,
        color: Colors.white,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(message),
    ],
  )));
}

String currencyFormat(dynamic money, {String? locale, String? symbol = ''}) {
  return NumberFormat.currency(decimalDigits: 2, locale: locale, symbol: symbol)
      .format(money);
}

class StudentExamResultItem extends StatelessWidget {
  StudentModel student;
  ExamResults examResults;
  bool showResult;
  StudentExamResultItem({
    required this.student,
    required this.examResults,
    this.showResult = true,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                  width: 220,
                  child: Text(
                    student.name!,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              examResults.grades.containsKey(student.id)
                  ? examResults.grades[student.id].toString()
                  : 'N/A',
              style: Theme.of(context).textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
                onPressed: () {
                  navigateTo(
                      context,
                      UpdateGradeScreen(
                          student: student,
                          examResults: examResults,
                          showResult: showResult));
                },
                icon: examResults.grades.containsKey(student.id)
                    ? examResults.grades[student.id].runtimeType != double
                        ? const Icon(
                            Icons.info_outline,
                            color: Colors.amberAccent,
                          )
                        : Icon(
                            Icons.edit_outlined,
                            color: defaultColor.withOpacity(0.8),
                          )
                    : const Icon(
                        Icons.info_outline,
                        color: Colors.amberAccent,
                      )),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}

Future<void> requestLocationPermission() async {
  final status = await Permission.location.request();

  if (status.isGranted) {
    // Permission granted, continue with your app logic
    // You can proceed with getting the user's location
  } else if (status.isDenied) {
    // Permission denied, show a message or UI to inform the user
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied, show a message or UI to guide the user to app settings
  }
}

class TransactionItem extends StatelessWidget {
  TransactionModel trans;
  void Function()? onTap;
  TransactionItem({required this.trans, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans.buyer.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      '${trans.totalPrice}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    getDate(trans.date, format: 'EE, hh:mm a'),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? checkToday(DateTime date) {
  DateTime now = DateTime.now();
  if (DateTime(date.year, date.month, date.day) ==
      DateTime(now.year, now.month, now.day)) {
    return 'Today';
  }
  return null;
}

class NoteList extends StatelessWidget {
  bool loadingCondition;
  NoteList({super.key, required this.loadingCondition});

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: TeacherCubit.get(context).notes != null,
        builder: (context) => loadingCondition
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ConditionalBuilder(
                condition: TeacherCubit.get(context).notes!.isNotEmpty,
                builder: (context) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: TeacherCubit.get(context).notes!.length,
                  itemBuilder: (context, index) {
                    return DefaultClassListCard(
                        onTap: () {
                          navigateTo(
                              context,
                              NoteDetailScreen(
                                  note:
                                      TeacherCubit.get(context).notes![index]));
                        },
                        teacherOnTap: () {
                          showDefaultDialog(
                            context,
                            title: 'Are you sure?',
                            content: Text(
                              'Are you sure you want to delete this note?',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            buttonText1: 'Cancel',
                            onPressed1: () => Navigator.pop(context),
                            buttonText2: 'Yes',
                            onPressed2: () {
                              TeacherCubit.get(context).deleteNote(
                                  noteId: TeacherCubit.get(context)
                                      .notes![index]
                                      .id!,
                                  noteFiles: TeacherCubit.get(context)
                                      .notes![index]
                                      .files);
                              Navigator.pop(context);
                            },
                          );
                        },
                        title: TeacherCubit.get(context).notes![index].title,
                        subtitle:
                            TeacherCubit.get(context).notes![index].subject,
                        date: TeacherCubit.get(context).notes![index].datetime);
                  },
                ),
                fallback: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/images/no_activity.png',
                        ),
                        height: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Notes Available',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
        fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/class_note.png',
                    ),
                    height: 300,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select a class to view its notes',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ));
  }
}

class AttendanceList extends StatelessWidget {
  bool loadingCondition;
  AttendanceList({super.key, required this.loadingCondition});

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: TeacherCubit.get(context).classLessonAttendace != null,
        builder: (context) => loadingCondition
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ConditionalBuilder(
                condition:
                    TeacherCubit.get(context).classLessonAttendace!.isNotEmpty,
                builder: (context) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: TeacherCubit.get(context)
                          .classLessonAttendace!
                          .length,
                      itemBuilder: (context, index) {
                        return DefaultClassListCard(
                            teacherOnTap: () {
                              showDefaultDialog(
                                context,
                                title: 'Are you sure?',
                                content: Text(
                                  'Are you sure you want to delete this lesson attendance?',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                buttonText1: 'Cancel',
                                onPressed1: () => Navigator.pop(context),
                                buttonText2: 'Yes',
                                onPressed2: () {
                                  TeacherCubit.get(context)
                                      .deleteClassAttendance(
                                          TeacherCubit.get(context)
                                              .classLessonAttendace![index]
                                              .id);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            onTap: () {
                              navigateTo(
                                  context,
                                  AttendanceDetailsScreen(
                                      lessonAttendance:
                                          TeacherCubit.get(context)
                                              .classLessonAttendace![index]));
                            },
                            title: TeacherCubit.get(context)
                                .classLessonAttendace![index]
                                .lessonName,
                            subtitle: TeacherCubit.get(context)
                                .classLessonAttendace![index]
                                .subject,
                            date: TeacherCubit.get(context)
                                .classLessonAttendace![index]
                                .datetime);
                      },
                    ),
                  ),
                ),
                fallback: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/images/no_activity.png',
                        ),
                        height: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No attendance has been taken yet',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
        fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/class_note.png',
                    ),
                    height: 300,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select a class to view its attendance history',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ));
  }
}

class GradesList extends StatelessWidget {
  GradesList({super.key, required this.loadingCondition});
  bool loadingCondition;
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
        condition: TeacherCubit.get(context).ClassExamsResults != null,
        builder: (context) => loadingCondition
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ConditionalBuilder(
                condition:
                    TeacherCubit.get(context).ClassExamsResults!.isNotEmpty,
                builder: (context) => SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          TeacherCubit.get(context).ClassExamsResults!.length,
                      itemBuilder: (context, index) {
                        return DefaultClassListCard(
                            onTap: () {
                              navigateTo(
                                  context,
                                  ExamResultsDetailsScreen(
                                      examResults: TeacherCubit.get(context)
                                          .ClassExamsResults![index]));
                            },
                            teacherOnTap: () {
                              showDefaultDialog(
                                context,
                                title: 'Are you sure?',
                                content: Text(
                                  'Are you sure you want to delete these exam results?',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                buttonText1: 'Cancel',
                                onPressed1: () => Navigator.pop(context),
                                buttonText2: 'Yes',
                                onPressed2: () {
                                  TeacherCubit.get(context).deleteExamResults(
                                      examResultsId: TeacherCubit.get(context)
                                          .ClassExamsResults![index]
                                          .id);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            title: TeacherCubit.get(context)
                                .ClassExamsResults![index]
                                .examType,
                            subtitle: TeacherCubit.get(context)
                                .ClassExamsResults![index]
                                .subject,
                            date: TeacherCubit.get(context)
                                .ClassExamsResults![index]
                                .datetime);
                      },
                    ),
                  ),
                ),
                fallback: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage(
                          'assets/images/no_activity.png',
                        ),
                        height: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Grades Available',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
        fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage(
                      'assets/images/class_note.png',
                    ),
                    height: 300,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Select a class to view its exams results',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ));
  }
}

class EmailVerificationMessage extends StatelessWidget {
  EmailVerificationMessage({super.key, required this.onPressed, required this.reload});
  bool reload;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Colors.yellowAccent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Please verify your email',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
                onPressed: onPressed,
                child: Text(reload? 'Refresh':'Send',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w900, color: defaultColor))),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
