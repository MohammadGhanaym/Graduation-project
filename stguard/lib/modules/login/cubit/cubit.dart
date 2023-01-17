import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void login({
    required var email,
    required var password,
  }) async {
    emit(LoginLoadingState());

    /*if (mAuth.currentUser != null) {
      emit(LoginSuccessState(mAuth.currentUser!.uid));
    } else {
      await mAuth.signInAnonymously().then((value) async {
        if (email != mAuth.currentUser!.email) {
          await mAuth.currentUser!.updateEmail(email).then((value) async {
            Map<String, dynamic> data = {};
            data['name'] = name;
            data['role'] = role;
            data['email'] = email;
            if (role == 'parent' || role == 'canteen worker') {
              data['balance'] = 0.0;
            }

            FirebaseFirestore.instance
                .collection('users')
                .doc(mAuth.currentUser!.uid)
                .set(data);
            emit(LoginSuccessState(mAuth.currentUser!.uid));
            print(mAuth.currentUser!.uid);
          }).catchError((error) {
            emit(LoginErrorState(error.toString()));
            print(error);
          });
        }
      });
    }*/
    /*
    if (mAuth.currentUser != null) {
      emit(LoginSuccessState(mAuth.currentUser!.uid));
    } else {
      await mAuth.signInAnonymously().then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(mAuth.currentUser!.uid)
            .get()
            .then((value) async {
          print('THIS IS LOGIN PAGE TEST');
          print(value.data());
          if (value.data() == null) {
            await mAuth.currentUser!.updateEmail(email).then((value) async {
              Map<String, dynamic> data = {};
              data['role'] = role;
              data['email'] = email;
              if (role == 'parent' || role == 'canteen worker') {
                data['balance'] = 0.0;
              }

              FirebaseFirestore.instance
                  .collection('users')
                  .doc(mAuth.currentUser!.uid)
                  .set(data);
              emit(LoginSuccessState(mAuth.currentUser!.uid));
              print(mAuth.currentUser!.uid);
            }).catchError((error) {
              emit(LoginErrorState(error.toString()));
              print(error);
            });
          } else {
            emit(LoginSuccessState(mAuth.currentUser!.uid));
          }
        });
      });
    }
    */

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginErrorState(error.toString().split('] ').last));
      print(error.toString().split('] ').last);
    });
  }
}
