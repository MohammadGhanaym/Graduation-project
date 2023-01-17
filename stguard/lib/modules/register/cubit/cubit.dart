import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/canteen_home_screen.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/layout/teacher/teacher_home_screen.dart';
import 'package:st_tracker/models/user_model.dart';
import 'package:st_tracker/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);
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

  void userRegister({
    required var email,
    required var password,
  }) async {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(uid: value.user!.uid, email: email, password: password);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString().split('] ').last));
      print(error.toString());
    });
  }

  void createUser(
      {required var uid, required var email, required var password}) {
    userModel user = userModel(id: uid, email: email, role: role);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toMap())
        .then((value) {
      emit(RegisterSuccessState(uid));
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
      print(error.toString().split('] ')[0]);
    });
  }

  Future<void> verifyEmail() async {
    var user = FirebaseAuth.instance.currentUser;
    print(user!.emailVerified);
    if (user.emailVerified == false) {
      await user.sendEmailVerification().then((value) {
        emit(EmailVerificationSendSuccess());
      }).catchError((error) {
        print(error.toString().split('] ')[0]);
        emit(EmailVerificationSendError());
      });
    }
  }
}
