import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/modules/login/cubit/cubit.dart';
import 'package:st_tracker/modules/login/cubit/states.dart';
import 'package:st_tracker/modules/register/register_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
                key: 'role', value: LoginCubit.get(context).role);
            CacheHelper.saveData(key: 'id', value: state.userID).then((value) {
              userID = state.userID;
              navigateAndFinish(
                  context, homeScreens[LoginCubit.get(context).role]);
            });
          } else if (state is LoginErrorState) {
            ShowToast(message: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {

          return Scaffold(
              body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // image
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image:
                                  AssetImage('assets/images/login_image.png'))),
                    ),
                    // title and subtitle
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello',
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Sign into your account',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontSize: 20, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ID and password fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          DefaultFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Email must not be empty';
                                }
                                return null;
                              },
                              label: 'Email',
                              prefix: Icons.email_outlined),
                          SizedBox(
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
                                passwordController.clear();
                                emailController.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton(
                            onPressed: () {
                              navigateTo(context, RegisterScreen());
                            },
                            child: Text('Register Now'))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 140,
                                child: RadioListTile<String>(
                                  activeColor: defaultColor,
                                  value: 'parent',
                                  groupValue: LoginCubit.get(context).role,
                                  onChanged: (value) {
                                    print(value);
                                    LoginCubit.get(context).isSelected(value);
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.grey[400]!),
                                      borderRadius: BorderRadius.circular(20)),
                                  title: Text('Parent'),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 140,
                                child: RadioListTile<String>(
                                  value: 'teacher',
                                  groupValue: LoginCubit.get(context).role,
                                  activeColor: defaultColor,
                                  onChanged: (value) {
                                    print(value);
                                    LoginCubit.get(context).isSelected(value);
                                  },
                                  title: Text('Teacher'),
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.grey[400]!),
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 140,
                            child: RadioListTile<String>(
                              value: 'canteen worker',
                              groupValue: LoginCubit.get(context).role,
                              activeColor: defaultColor,
                              onChanged: (value) {
                                print(value);
                                LoginCubit.get(context).isSelected(value);
                              },
                              title: Text('Canteen Worker'),
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // sign in button
                    state is LoginLoadingState
                        ? LoadingOnWaiting(height: screen_height * 0.07, width: screen_width * 0.5,
                        color: defaultColor.withOpacity(0.8),)
                        : DefaultButton(
                            text: 'SIGN IN',
                         height: screen_height * 0.07, width: screen_width * 0.5,
                            color: defaultColor.withOpacity(0.8),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                passwordController.clear();
                                emailController.clear();
                              }
                            },
                          )
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
