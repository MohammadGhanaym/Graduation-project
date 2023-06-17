import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:stguard/shared/main_cubit/main_cubit.dart';
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
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.data.toString());
      print('onMessageOpenedApp');
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
        BlocProvider(create: (context) => MainCubit()),
        BlocProvider(
          create: (context) => ParentCubit(),
        ),
        BlocProvider(
          create: (context) => TeacherCubit(),
        ),
        BlocProvider(create: (context) => CanteenCubit()),
      ],
      child: MaterialApp(
        home: startScreen,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(color: defaultColor),
            primaryColor: defaultColor,
            textTheme: TextTheme(
                titleLarge: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontFamily: 'OpenSans'),
                titleMedium: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontFamily: 'OpenSans'),
                headlineSmall: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(
                        fontFamily: 'OpenSans', fontWeight: FontWeight.w700),
                headlineMedium: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(fontFamily: 'OpenSans'),
                bodyLarge: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontFamily: 'OpenSans'),
                bodySmall: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontFamily: 'OpenSans', fontSize: 15))),
      ),
    );
  }
}
