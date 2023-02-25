import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/canteen_home_screen.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/shared/bloc_observer.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  userID = CacheHelper.getData(key: 'id');
  userRole = CacheHelper.getData(key: 'role');
  Widget startScreen = LoginScreen();
  if (userID != null) {
    startScreen = homeScreens[userRole]!;
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
        BlocProvider(
          create: (context) => ParentCubit()
            ..createDatabase()
            ..getParentInfo()
            ..getMyStudents()
            ..startBackgroundService(),
        ),
        BlocProvider(
          create: (context) => TeacherCubit()
            ..initDatabase()
            ..getTeacherInfo()
            ..getTeacherPath(),
        ),
        BlocProvider(
            create: (context) => CanteenCubit()
              ..getCanteenInfo()
              ..getCanteenPath())
      ],
      child: MaterialApp(
        home: CanteenHomeScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: defaultColor),
          primaryColor: Colors.blueAccent,
          scaffoldBackgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
