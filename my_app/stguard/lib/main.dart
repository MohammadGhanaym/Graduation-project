import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/modules/login/login_screen.dart';
import 'package:stguard/shared/bloc_observer.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/internet_cubit/cubit.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';
import 'package:stguard/shared/styles/themes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print('onBackgroundMessage');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  userID = CacheHelper.getData(key: 'id');
  userRole = CacheHelper.getData(key: 'role');
  Widget startScreen = LoginScreen();
  if (userID != null) {
    if (userRole == 'parent') {
      FirebaseMessaging.instance.getToken();
      FirebaseMessaging.onMessage.listen((event) {
        print(event.data.toString());
        print('onMessage');
      });

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        print(event.data.toString());
        print('onMessageOpenedApp');
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
    startScreen = homeScreens[userRole]!;
  }

  runApp(BlocProvider(
    create: (context) => InternetCubit(Connectivity()),
    child: MyApp(
      startScreen: startScreen,
    ),
  ));
}

class MyApp extends StatelessWidget {
  Widget startScreen;
  MyApp({super.key, required this.startScreen});
  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ParentCubit()
                ..createDatabase()
                ..getMyStudents()
                ..getParentInfo(),
        ),
        BlocProvider(
          create: (context) => TeacherCubit()
            ..initDatabase()
            ..getTeacherPath(),
        ),
        BlocProvider(
            create: (context) => CanteenCubit()
              ..getCanteenInfo()
              ..getCanteenPath())
      ],
      child: MaterialApp(
        home: startScreen,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: defaultColor),
          primaryColor: defaultColor,
        ),
      ),
    );
  }
}
