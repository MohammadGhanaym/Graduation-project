import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/main_cubit/states.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitState());
  static MainCubit get(context) => BlocProvider.of(context);

  bool reload = false;
  void verifyEmail() async {
    await FirebaseAuth.instance.currentUser!
        .sendEmailVerification()
        .then((value) {
      emit(EmailVerificationSuccessState());
      reload = true;
    }).catchError((error) {
      emit(EmailVerificationErrorState());
    });
  }

  void refreshUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload().then((value) {
      print(user.emailVerified);
      if (user.emailVerified) {
        emailVerified = user.emailVerified;
        print(user.emailVerified);
        emit(EmailVerificationChangeState());
        reload = false;
      }
    }).catchError((error) {
      print(error.toString());
    });
  }
}
