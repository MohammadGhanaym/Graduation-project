import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void login({
    required var email,
    required var password,
  }) async {
    emit(LoginLoadingState());
 FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (role == 'parent') {
        checkRole('Parents', value.user!.uid);
      } else if (role == 'teacher') {
        checkRole('Teachers', value.user!.uid);
      } else if (role == 'canteen worker') {
        checkRole('Canteen Workers', value.user!.uid);
      }
    }).catchError((error) {
      emit(LoginErrorState(error.toString().split('] ').last));
      print(error.toString().split('] ').last);
    });
  }

  void checkRole(String collName, dynamic uid) {
    FirebaseFirestore.instance.collection(collName).doc(uid).get().then((user) {
      if (user.data() != null) {
        if (role != user['role']) {
          emit(LoginErrorState('You are not a $role'));
        } else {
          emit(LoginSuccessState(uid));
        }
      } else {
        emit(LoginErrorState("You don't have an account"));
      }
    });
  }
}
