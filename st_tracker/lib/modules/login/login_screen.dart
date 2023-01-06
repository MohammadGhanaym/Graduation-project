import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/modules/login/cubit/cubit.dart';
import 'package:st_tracker/modules/login/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var IdController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(
                key: 'role', value: LoginCubit.get(context).role);
            CacheHelper.saveData(
                    key: 'id', value: LoginCubit.get(context).user!.id)
                .then((value) {
              navigateAndFinish(
                  context,
                  LoginCubit.get(context)
                      .homeScreens[LoginCubit.get(context).role]);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
              body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // image
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
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
                            controller: IdController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Enter correct ID';
                              }
                              return null;
                            },
                            label: 'ID',
                            prefix: Icons.perm_identity_outlined),
                        SizedBox(
                          height: 15,
                        ),
                        DefaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: LoginCubit.get(context).suffix,
                            isPassword: LoginCubit.get(context).isPassword,
                            changeObscured: (() {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            }),
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Enter correct password';
                              }
                              return null;
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline),
                      ],
                    ),
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
                                    side: BorderSide(color: Colors.grey[400]!),
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
                                    side: BorderSide(color: Colors.grey[400]!),
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
                      ? CircularProgressIndicator()
                      : Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              borderRadius: BorderRadius.circular(10)),
                          child: MaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    IdController.text, passwordController.text);
                              }
                            },
                            child: Text(
                              'SIGN IN',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
