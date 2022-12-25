import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/canteen_home_screen.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/parent_home_screen.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/teacher_home_screen.dart';
import 'package:st_tracker/modules/login/cubit/cubit.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/shared/bloc_observer.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/background_service.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/network/local/life_cycle_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundService.initializeService();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  //DioHelper.init();

  userID = CacheHelper.getData(key: 'id');
  userRole = CacheHelper.getData(key: 'role');
  Widget startScreen = LoginScreen();
  Cubit mainCubit = LoginCubit();
  if (userID != null) {
    if (userRole == 'teacher') {
      startScreen = TeacherHomeScreen();
      mainCubit = TeacherCubit();
    } else if (userRole == 'parent') {
      startScreen = ParentHomeScreen();
      mainCubit = ParentCubit();
    } else {
      startScreen = CanteenHomeScreen();
      mainCubit = CanteenCubit();
    }
  }
  runApp(MyApp(
    startScreen: startScreen,
    cubit: mainCubit,
  ));
}

class MyApp extends StatelessWidget {
  Widget startScreen;
  Cubit cubit;
  MyApp({required this.startScreen, required this.cubit});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: ParentCubit())],
      child: MaterialApp(
        home: startScreen,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}