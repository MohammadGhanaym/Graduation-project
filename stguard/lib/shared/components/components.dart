import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/models/activity_model.dart';
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
      this.height = 50,
      this.color = defaultColor,
      this.radius = 10,
      required this.text,
      this.textColor = Colors.white,
      this.textSize = 20,
      this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadiusDirectional.circular(10)),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: textSize),
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
  bool isPassword = false;
  String? Function(String? value) validate;
  String? label;
  IconData? prefix;
  IconData? suffix;
  void Function()? changeObscured;
  bool isClickable = true;

  DefaultFormField(
      {required this.controller,
      required this.type,
      this.onSubmit,
      this.onChange,
      this.onTap,
      this.isPassword = false,
      required this.validate,
      required this.label,
      this.prefix,
      IconData? this.suffix,
      this.changeObscured,
      this.isClickable = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(icon: Icon(suffix), onPressed: changeObscured)
              : null),
      validator: validate,
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
      value.cancel();
    });
    transListeners = {};
  }

  if (attendListeners.isNotEmpty) {
    attendListeners.forEach((key, value) {
      value.cancel();
    });
    attendListeners = {};
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      onTap: ontap,
      highlightColor: defaultColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(5),
    );
  }
}

class ActivityItem extends StatelessWidget {
  ActivityModel model;
  List<studentModel?> studentsData;
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
      child: Container(
          height: 90,
          width: double.infinity,
          child: Card(
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
                      backgroundColor: Colors.grey[300],
                    ),
                    Image(
                      image: model.trans_id != 'null'
                          ? const AssetImage('assets/images/purchase.png')
                          : const AssetImage('assets/images/movement.png'),
                      width: 45,
                      height: 35,
                      fit: BoxFit.scaleDown,
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 160,
                    child: Text(
                      model.trans_id != 'null'
                          ? '$name Puchased'
                          : '$name ${model.activity}',
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('${getDate(model.date)}')
                ]),
                SizedBox(
                  width: 10,
                ),
                model.trans_id != 'null'
                    ? Text(
                        '-${model.activity}',
                        style: TextStyle(fontSize: 16),
                      )
                    : Row(
                        children: [
                          model.activity == 'Arrived'
                              ? SizedBox(
                                  width: 10,
                                )
                              : SizedBox(
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
                      )
              ],
            ),
          ))),
    );
    ;
  }
}

class FamilyMemberCard extends StatelessWidget {
  studentModel? model;
  FamilyMemberCard(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => navigateTo(context, MemberSettingsScreen(student: model)),
      child: Container(
        padding: EdgeInsets.zero,
        height: 140,
        width: 130,
        child: Card(
          child: Container(
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 41,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(model!.image!),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: 80,
                      child: Center(
                          child: Text(
                        '${model!.name!.split(' ')[0]}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      )))
                ]),
          ),
        ),
      ),
    );
  }
}

dynamic getDate(date, {format = 'EE, hh:mm a'}) {
  if (date is String) {
    return DateFormat(format).format(DateTime.parse(date));
  } else {
    return DateFormat(format).format(date);
  }
}

class ProductItem extends StatelessWidget {
  ProductModel product;
  ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              product.product_name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Price:',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 5,
                ),
                Text(
                  product.price,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class AttendanceHistoryItem extends StatelessWidget {
  ActivityModel model;
  AttendanceHistoryItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screen_width * 0.6,
      height: screen_height * 0.1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${getDate(model.date, format: 'EEEE')}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screen_height * 0.01,
                  ),
                  Text('${getDate(model.date, format: 'yyyy-MM-dd')}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
                ],
              ),
              VerticalDivider(
                color: Theme.of(context).primaryColor,
                thickness: 0.5,
              ),
              SizedBox(width: screen_width * 0.05),
              Text('${getDate(model.date, format: 'hh:mm:ss')}'),
              model.activity == 'Arrived'
                  ? SizedBox(width: screen_width * 0.16)
                  : SizedBox(width: screen_width * 0.18),
              ImageIcon(AssetImage('assets/images/${model.activity}.png'),
                  color:
                      model.activity == 'Arrived' ? Colors.green : Colors.red)
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
  SettingsCard(
      {super.key, required this.children, this.card_width, this.card_height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(10))),
      width: card_width,
      height: card_height,
      child: Card(
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: children,
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SliderSideLabel(
            value: 0,
            type: 'min',
          ),
          SliderTheme(
            data: SliderThemeData(trackHeight: 3),
            child: Expanded(
              child: Slider(
                value: ParentCubit.get(context).pocket_money,
                min: 0,
                max: 500,
                label: '${ParentCubit.get(context).pocket_money}',
                divisions: (500 / 5).toInt(),
                onChanged: (value) {
                  if (value <= ParentCubit.get(context).balance) {
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
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ));
  }
}

class RechargeItem extends StatelessWidget {
  String leadIcon;
  double? iconSize;
  String text;
  double width;
  void Function()? ontap;
  RechargeItem(
      {super.key,
      required this.leadIcon,
      this.iconSize,
      required this.text,
      required this.width,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
          width: double.infinity,
          height: screen_height * 0.15,
          child: Card(
              child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20),
            child: Row(children: [
              Image(
                image: AssetImage(leadIcon),
                width: iconSize,
                height: iconSize,
              ),
              SizedBox(
                width: screen_width * 0.05,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: width,
              ),
              Icon(Icons.arrow_forward_ios_outlined,
                  size: 20, color: defaultColor)
            ]),
          ))),
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
    return Container(
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
  double width;
  double height;
  BuildContext context;
  AllergenSelectionItem(
      {super.key,
      required this.icon,
      required this.context,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (ParentCubit.get(context).selectedAllergens.contains(icon)) {
          ParentCubit.get(context).removeAllergen(icon);
        } else {
          ParentCubit.get(context).addAllergen(icon);
        }
        print(ParentCubit.get(context).selectedAllergens);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10),
            border: Border.all(
                width: width * 0.01,
                color: ParentCubit.get(context).selectedAllergens.contains(icon)
                    ? defaultColor
                    : Theme.of(context).scaffoldBackgroundColor)),
        width: width * 0.1,
        height: height * 0.01,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/${icon.toLowerCase()}.png'),
                  width: width * 0.15,
                  color: defaultColor,
                  height: height * 0.06,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Text(
                  '$icon',
                  style: TextStyle(
                      fontSize: width * 0.05, fontWeight: FontWeight.w500),
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
      required this.height,
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
        child: Center(
            child: const CircularProgressIndicator(
          color: Colors.white,
        )));
  }
}

class MyDropdown extends StatelessWidget {
  double width;
  double height;
  double radius;
  Color borderColor;
  MyDropdown(
      {super.key,
      required this.width,
      required this.height,
      required this.radius,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    print(width);
    return Container(
      alignment: AlignmentDirectional.center,
      width: width * 0.4,
      height: height * 0.05,
      margin: EdgeInsets.all(width * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.01),
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: width * 0.002),
          borderRadius: BorderRadiusDirectional.circular(radius)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: TeacherCubit.get(context).selectedGrade,
          hint: Text(
            'Select Grade',
            style: TextStyle(fontSize: width * 0.04),
          ),
          isExpanded: true,
          onChanged: (value) {
            TeacherCubit.get(context).selectGrade(value);
          },
          iconSize: width * 0.07,
          icon: Icon(Icons.arrow_drop_down_outlined),
          items: TeacherCubit.get(context).grades.map((item) {
            return DropdownMenuItem<String>(
              alignment: AlignmentDirectional.center,
              value: item,
              child: Text(
                item,
                style: TextStyle(fontSize: width * 0.05),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class StudentAttendanceCard extends StatelessWidget {
  double width;
  double height;
  studentModel student;

  StudentAttendanceCard({
    super.key,
    required this.width,
    required this.height,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(width * 0.02),
            border: Border.all(
                width: width * 0.01,
                color: TeacherCubit.get(context).attendance[student.id!] != null
                    ? TeacherCubit.get(context)
                                .attendance[student.id!]
                                .isPresent ==
                            1
                        ? defaultColor.withOpacity(0.8)
                        : Colors.red.withOpacity(0.8)
                    : Colors.grey[200]!)),
        width: width,
        height: height * 0.15,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: width * 0.1,
                backgroundImage: NetworkImage(student.image!),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: width * 0.5,
                      child: Text(
                        student.name!,
                        style: TextStyle(
                            fontSize: screen_width * 0.05,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DefaultButton(
                        text: 'Present',
                        color: defaultColor.withOpacity(0.8),
                        width: width * 0.29,
                        height: height * 0.05,
                        onPressed: () {
                          TeacherCubit.get(context)
                              .addtoAttendance(student.id!, student.name!, 1);
                        },
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      DefaultButton(
                        text: 'Absent',
                        color: Colors.red.withOpacity(0.8),
                        width: width * 0.27,
                        height: height * 0.05,
                        onPressed: () {
                          TeacherCubit.get(context)
                              .addtoAttendance(student.id!, student.name!, 0);
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
  double width;
  double height;
  LessonCard(
      {required this.width,
      required this.height,
      required this.lesson,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height * 0.12,
        child: Card(
            child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.05),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screen_width * 0.6,
                    child: Text(
                      '${lesson.name.substring(0, 1).toUpperCase()}${lesson.name.substring(1)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: width * 0.05, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    children: [
                      Text(lesson.grade,
                          style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: width * 0.2,
                      ),
                      Text(getDate(lesson.datetime, format: 'MMM, EE, hh:mm a'),
                          style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500))
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
    return Container(
      width: screen_width,
      height: screen_height * 0.05,
      child: Padding(
        padding: EdgeInsets.all(screen_width * 0.02),
        child: Row(
          children: [
            Container(
                width: screen_width * 0.57,
                child: Text(
                  studentDetails.studentName,
                  maxLines: 2,
                  style: TextStyle(fontSize: screen_width * 0.04),
                  overflow: TextOverflow.ellipsis,
                )),
            VerticalDivider(
              color: defaultColor.withOpacity(0.8),
              thickness: 1,
            ),
            ImageIcon(
              color: studentDetails.isPresent == 1
                  ? defaultColor.withOpacity(0.8)
                  : Colors.red.withOpacity(0.8),
              AssetImage(studentDetails.isPresent == 1
                  ? 'assets/images/check-mark.png'
                  : 'assets/images/close.png'),
              size: screen_width * 0.1,
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
