import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/teacher/cubit/cubit.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/shared/bloc_observer.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/network/remote/dio_helper.dart';
import 'package:st_tracker/shared/styles/themes.dart';

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
    if(userRole == 'parent')
    {
  FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    print('onMessage');
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    print('onMessageOpenedApp');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    }
    startScreen = homeScreens[userRole]!;
  }

  runApp(MyApp(
    startScreen: startScreen,
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
          create: (context) => ParentCubit()
            ..createDatabase()
            ..getParentInfo(),
        ),
        BlocProvider(
          create: (context) => TeacherCubit()
            ..initDatabase()
            ..getTeacherInfo()
            ..getTeacherPath(),
        ),
        BlocProvider(
            create: (context) => CanteenCubit()
              ..initialize()
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
