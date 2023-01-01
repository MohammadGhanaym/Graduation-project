import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'package:st_tracker/shared/network/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  //CacheHelper.removeData(key: 'IDsList');

  userID = CacheHelper.getData(key: 'id');
  userRole = CacheHelper.getData(key: 'role');
  Widget startScreen = LoginScreen();
  if (userID != null) {
    if (userRole == 'teacher') {
      startScreen = TeacherHomeScreen();
    } else if (userRole == 'parent') {
      startScreen = ParentHomeScreen();
    } else {
      startScreen = CanteenHomeScreen();
    }
  }
  runApp(MyApp(
    startScreen: startScreen,
  ));
}

class MyApp extends StatelessWidget {
  Widget startScreen;
  MyApp({required this.startScreen});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiBlocProvider(
      providers: [
        if (userRole == 'parent')
          BlocProvider(
              create: (context) => ParentCubit()
                ..createDatabase()
                ..getStudentsData()
                ..initBackgroundService()
                ..getData()
                ..getDataFromActivityTable()),
      ],
      child: MaterialApp(
        home: startScreen,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blueAccent),
          primaryColor: Colors.blueAccent,
          scaffoldBackgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
