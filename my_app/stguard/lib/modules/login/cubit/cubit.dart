import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/modules/login/cubit/states.dart';

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

  bool readOnly = true;
  void changeReadOnly({bool value = false}) {
    readOnly = value;
    print(readOnly);
    emit(ChangeReadOnlyState());
  }

  void login({
    required var email,
    required var password,
  }) async {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async{
      if (role == 'parent') {
        checkRole('Parents', value.user!.uid);
      } else if (role == 'teacher') {
        checkRole('Teachers', value.user!.uid);
      } else if (role == 'canteen worker') {
        checkRole('Canteen Workers', value.user!.uid);
      }
      print(await value.user!.getIdToken());
    }).catchError((error) {
      emit(LoginErrorState(error.toString().split('] ').last));
      print(error.toString().split('] ').last);
    });
  }

  Future<void> checkRole(String collName, dynamic uid) async {
    await FirebaseFirestore.instance
        .collection(collName)
        .doc(uid)
        .get()
        .then((user) async {
      if (user.exists) {
        if (role == 'parent') {
          await FirebaseFirestore.instance
              .collection(collName)
              .doc(uid)
              .update({
            'device_token': await FirebaseMessaging.instance.getToken()
          }).then((value) {
            emit(LoginSuccessState(uid, role));
          }).catchError((error) {
            print(error.toString());
            emit(LoginErrorState('Connection Error!'));
          });
        } else {
          emit(LoginSuccessState(uid, role));
        }
      } else {
        emit(LoginErrorState('You are not a $role'));
      }
    });
  }

  bool isLoading = false;
  void changeLoading(bool value) {
    isLoading = value;
    emit(ChangeLoadingState());
  }

  void forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        emit(SendPasswordResetEmailSuccessState());
      });
    } catch (e) {
      emit(SendPasswordResetEmailErrorState(e.toString()));
    } finally {
      isLoading = false;
    }
  }
}
