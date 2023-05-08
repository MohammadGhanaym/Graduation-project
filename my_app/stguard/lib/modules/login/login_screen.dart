import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/parent/cubit/cubit.dart';
import 'package:stguard/layout/teacher/cubit/cubit.dart';
import 'package:stguard/modules/login/cubit/cubit.dart';
import 'package:stguard/modules/login/cubit/states.dart';
import 'package:stguard/modules/register/register_screen.dart';
import 'package:stguard/modules/reset_password/reset_password_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:stguard/shared/network/local/cache_helper.dart';
import 'package:stguard/shared/styles/Themes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) async {
          if (state is LoginSuccessState) {
            LoginCubit.get(context).changeReadOnly(value: true);
            await CacheHelper.saveData(
                key: 'role', value: LoginCubit.get(context).role);
            await CacheHelper.saveData(key: 'id', value: state.userID)
                .then((value) {
              userID = state.userID;
              userRole = state.userRole;
              navigateAndFinish(context, homeScreens[userRole]);
            });
          } else if (state is LoginErrorState) {
            ShowToast(message: state.error, state: ToastStates.ERROR);
            LoginCubit.get(context).changeReadOnly(value: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
              body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Column(
                  children: [
                    // image

                    Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 40),
                      alignment: AlignmentDirectional.center,
                      height: 310,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Theme.of(context).primaryColor),
                      child: Column(
                        children: [
                          const Image(
                              color: Colors.white,
                              width: 180,
                              height: 180,
                              image: AssetImage('assets/images/school.png')),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Welcome',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Sign into your account',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // title and subtitle

                    // ID and password fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              DefaultFormField(
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  isClickable: LoginCubit.get(context).readOnly,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Email',
                                  prefix: Icons.email_outlined),
                              const SizedBox(
                                height: 15,
                              ),
                              DefaultFormField(
                                controller: passwordController,
                                isPassword: LoginCubit.get(context).isPassword,
                                type: TextInputType.visiblePassword,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Password',
                                isClickable: LoginCubit.get(context).readOnly,
                                changeObscured: () => LoginCubit.get(context)
                                    .changePasswordVisibility(),
                                prefix: Icons.password_outlined,
                                suffix: LoginCubit.get(context).suffix,
                                onSubmit: (p0) {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                navigateTo(
                                    context,
                                    BlocProvider.value(
                                        value: LoginCubit.get(context),
                                        child: ResetPasswordScreen()));
                              },
                              child: const Text('Forgot password?')),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DefaultRadioListTile(
                                        value: 'parent',
                                        groupValue:
                                            LoginCubit.get(context).role,
                                        onChanged: (value) {
                                          print(value);
                                          LoginCubit.get(context)
                                              .isSelected(value);
                                        },
                                        title: 'Parent'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    DefaultRadioListTile(
                                        value: 'teacher',
                                        groupValue:
                                            LoginCubit.get(context).role,
                                        onChanged: (value) {
                                          print(value);
                                          LoginCubit.get(context)
                                              .isSelected(value);
                                        },
                                        title: 'Teacher'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DefaultRadioListTile(
                                    value: 'canteen worker',
                                    groupValue: LoginCubit.get(context).role,
                                    onChanged: (value) {
                                      print(value);
                                      LoginCubit.get(context).isSelected(value);
                                    },
                                    title: 'Canteen Worker'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          // sign in button
                          DefaultButton(
                            text: 'SIGN IN',
                            height: 55,
                            showCircularProgressIndicator:
                                state is LoginLoadingState,
                            color: defaultColor.withOpacity(0.8),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).login(
                                  email:
                                      emailController.text.replaceAll(' ', ''),
                                  password: passwordController.text,
                                );
                                LoginCubit.get(context)
                                    .changeReadOnly(value: false);
                              }
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: const Text('Register Now'))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
