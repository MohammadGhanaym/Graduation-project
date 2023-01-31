import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/modules/register/cubit/cubit.dart';
import 'package:st_tracker/modules/register/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            ShowToast(message: 'Success', state: ToastStates.SUCCESS);
            navigateAndFinish(context, LoginScreen());
          } else if (state is RegisterErrorState) {
            ShowToast(message: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
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
                                image: AssetImage(
                                    'assets/images/login_image.png'))),
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
                                'Create an Account',
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
                                controller: nameController,
                                type: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name must not be empty';
                                  }
                                  return null;
                                },
                                label: 'Name',
                                prefix: Icons.person_outlined),
                            SizedBox(
                              height: 15,
                            ),
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
                              isPassword: RegisterCubit.get(context).isPassword,
                              type: TextInputType.visiblePassword,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Password must not be empty';
                                }
                                return null;
                              },
                              label: 'Password',
                              changeObscured: () => RegisterCubit.get(context)
                                  .changePasswordVisibility(),
                              prefix: Icons.password_outlined,
                              suffix: RegisterCubit.get(context).suffix,
                              onSubmit: (p0) {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                  nameController.clear();
                                  passwordController.clear();
                                  emailController.clear();
                                }
                              },
                            ),
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
                                    groupValue: RegisterCubit.get(context).role,
                                    onChanged: (value) {
                                      print(value);
                                      RegisterCubit.get(context)
                                          .isSelected(value);
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.grey[400]!),
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                                    groupValue: RegisterCubit.get(context).role,
                                    activeColor: defaultColor,
                                    onChanged: (value) {
                                      print(value);
                                      RegisterCubit.get(context)
                                          .isSelected(value);
                                    },
                                    title: Text('Teacher'),
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.grey[400]!),
                                        borderRadius:
                                            BorderRadius.circular(20)),
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
                                groupValue: RegisterCubit.get(context).role,
                                activeColor: defaultColor,
                                onChanged: (value) {
                                  print(value);
                                  RegisterCubit.get(context).isSelected(value);
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
                      state is RegisterLoadingState
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
                                    RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    nameController.clear();
                                    passwordController.clear();
                                    emailController.clear();
                                  }
                                },
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
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
