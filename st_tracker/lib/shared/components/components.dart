import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:st_tracker/models/transactions_model.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
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

  navigateAndFinish(context, LoginScreen());
}

class DrawerItem extends StatelessWidget {
  IconData? icon;
  String text;
  void Function()? ontap;
  DrawerItem({required this.text, this.icon, this.ontap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Icon(
            icon,
            size: 35,
          ),
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

Widget buildActivityItem(TransactionsModel model) => Container(
    height: 80,
    width: double.infinity,
    child: Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Image(
              image: AssetImage('assets/images/purchase.png'),
              width: 30,
              height: 35,
              fit: BoxFit.scaleDown,
              alignment: FractionalOffset.center,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text('Purchase'),
                  SizedBox(
                    width: 105,
                  ),
                  Text(
                      '${DateFormat('EE, hh:mm a').format(DateTime.parse(model.date))}')
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      '${model.product_name}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text('-${model.price}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text('EGP'),
                  ),
                ],
              )
            ])
          ],
        ),
      ),
    )));
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
                