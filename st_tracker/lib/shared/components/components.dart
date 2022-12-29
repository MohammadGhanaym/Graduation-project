import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:st_tracker/models/activity_model.dart';
import 'package:st_tracker/models/student_model.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/modules/parent/attendance_history/attendance_history_screen.dart';
import 'package:st_tracker/modules/parent/member_settings/member_settings.dart';
import 'package:st_tracker/modules/parent/transaction_details/transaction_details_screen.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';

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
  if (trans_listener != null) {
    trans_listener!.cancel();
  }
  FlutterBackgroundService().invoke('stopService');
  navigateAndFinish(context, LoginScreen());
}

class DrawerItem extends StatelessWidget {
  dynamic? icon;
  String text;
  void Function()? ontap;
  DrawerItem({required this.text, this.icon, this.ontap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            width: 5,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
      onTap: ontap,
    );
  }
}

Widget buildActivityItem(BuildContext context, ActivityModel model,
    List<studentModel?> studentsData) {
  String? name;
  print(model.trans_id);
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
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Stack(
                  alignment: model.trans_id != 'null'
                      ? AlignmentDirectional.centerStart
                      : AlignmentDirectional.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                    ),
                    Image(
                      image: model.trans_id != 'null'
                          ? const AssetImage('assets/images/purchase.png')
                          : const AssetImage('assets/images/movement.png'),
                      width: 55,
                      height: 35,
                      fit: BoxFit.scaleDown,
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    model.trans_id != 'null'
                        ? '$name Puchased'
                        : '$name ${model.activity}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      '${DateFormat('EE, hh:mm a').format(DateTime.parse(model.date))}')
                ]),
                SizedBox(
                  width: 70,
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
                                  width: 20,
                                )
                              : SizedBox(
                                  width: 30,
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
          ),
        ))),
  );
}

Widget buildFamilyMemberCard(studentModel? model, context) => InkWell(
      onTap: () => navigateTo(context, MemberSettingsScreen(student: model)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.zero,
          height: 150,
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
                          '${model.name!.split(' ')[0]}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        )))
                  ]),
            ),
          ),
        ),
      ),
    );



/*Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.zero,
                                  height: 180,
                                  width: 130,
                                  child: Card(
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CircleAvatar(
                                              radius: 41,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              child: CircleAvatar(
                                                  radius: 40,
                                                  backgroundColor: Colors.white,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        navigateTo(
                                                            context,
                                                            BlocProvider.value(
                                                                value: ParentCubit
                                                                    .get(
                                                                        context),
                                                                child:
                                                                    AddMember()));
                                                      },
                                                      icon: Icon(Icons.add))),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                                width: 80,
                                                child:
                                                    Text('Add Family Member'))
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            )*/
/*Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        child: RadioListTile<String>(
                          value: 'Parent',
                          groupValue: LoginCubit.get(context).role,
                          onChanged: (value) {
                            print(value);
                            LoginCubit.get(context).isSelected(value);
                          },
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey[500]!),
                              borderRadius: BorderRadius.circular(10)),
                          title: Text('Parent'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 150,
                        child: RadioListTile<String>(
                          value: 'Teacher',
                          groupValue: LoginCubit.get(context).role,
                          onChanged: (value) {
                            print(value);
                            LoginCubit.get(context).isSelected(value);
                          },
                          title: Text('Teacher'),
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey[500]!),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 150,
                        child: RadioListTile<String>(
                          value: 'Canteen Worker',
                          groupValue: LoginCubit.get(context).role,
                          onChanged: (value) {
                            print(value);
                            LoginCubit.get(context).isSelected(value);
                          },
                          title: Text('Canteen Worker'),
                          contentPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey[500]!),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )*/
                