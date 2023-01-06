import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/canteen_home_screen.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/layout/teacher/teacher_home_screen.dart';
import 'package:st_tracker/models/user_model.dart';
import 'package:st_tracker/modules/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);
  String? role = 'parent';
  void isSelected(String? value) {
    role = value;
    emit(RadioButtonSelected());
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }

  userModel? user;
  Map<String, Widget> homeScreens = {
    'parent': ParentHomeScreen(),
    'teacher': TeacherHomeScreen(),
    'canteen worker': CanteenHomeScreen()
  };

  void userLogin(String id, String password) {
    emit(LoginLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: role)
        .where('UID', isEqualTo: id)
        .where('password', isEqualTo: password)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        user = userModel.fromJson(value.docs[0].data());
        print(user!.id);
        emit(LoginSuccessState(user!.id!));
      }
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
      print(error.toString());
    });
  }
}
