import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/models/canteen_model.dart';
import 'package:stguard/models/parent_model.dart';
import 'package:stguard/models/teacher_model.dart';
import 'package:stguard/modules/register/cubit/states.dart';

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
    required var name,
    required var email,
    required var password,
  }) async {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
          uid: value.user!.uid, name: name, email: email, password: password);
    }).catchError((error) {
      emit(RegisterErrorState(error.toString().split('] ').last));
      print(error.toString());
    });
  }

  void createUser(
      {required var uid,
      required var name,
      required var email,
      required var password}) {
    if (role == 'parent') {
      ParentModel user = ParentModel(
          id: uid, name: name, email: email, balance: 0, role: role!);
      saveUserData(user, 'Parents');
    } else if (role == 'teacher') {
      TeacherModel user =
          TeacherModel(id: uid, name: name, email: email, role: role!);
      saveUserData(user, 'Teachers');
    } else if (role == 'canteen worker') {
      CanteenWorkerModel user = CanteenWorkerModel(
          id: uid, name: name, email: email, balance: 0, role: role!);
      saveUserData(user, 'Canteen Workers');
    }
  }

  void saveUserData(dynamic user, String collName) {
    FirebaseFirestore.instance
        .collection(collName)
        .doc(user.id)
        .set(user.toMap())
        .then((value) {
      emit(RegisterSuccessState(user.id));
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
