import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/modules/login/login_screen.dart';
import 'package:st_tracker/modules/register/cubit/cubit.dart';
import 'package:st_tracker/modules/register/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/network/local/cache_helper.dart';
import 'package:st_tracker/shared/styles/themes.dart';

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
              appBar: AppBar(elevation: 0.0,),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // image
                      Container(
                        padding:
                          const EdgeInsets.only(left: 20, right: 20),
                      alignment: AlignmentDirectional.center,
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Theme.of(context).primaryColor),
                          child:Column(
                            children: [
                              Image(
                                color: Colors.white,
                                width: 150,
                                height: 150,
                                image: 
                              AssetImage(
                                        'assets/images/user.png')),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                'Create an Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white)
                              ),
                                          ],
                                        )
                            ],
                          ) ,
                        
                      ),
                      SizedBox(height: 20,),
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
                                  
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DefaultRadioListTile(value: 'parent', 
                                groupValue: RegisterCubit.get(context).role, 
                                onChanged: (value) {
                                      print(value);
                                      RegisterCubit.get(context)
                                          .isSelected(value);
                                    }, 
                                title: 'Parent'),
                               SizedBox(
                                  width: 10,
                                ),
                                DefaultRadioListTile(value: 'teacher', 
                                groupValue: RegisterCubit.get(context).role, 
                                onChanged: (value) {
                                      print(value);
                                      RegisterCubit.get(context)
                                          .isSelected(value);
                                    }, 
                                title: 'Teacher')
                                ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DefaultRadioListTile(value: 'canteen worker', 
                            groupValue: RegisterCubit.get(context).role, 
                            onChanged: (value) {
                                  print(value);
                                  RegisterCubit.get(context).isSelected(value);
                                }, 
                            title: 'Canteen Worker')
                            ,
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // sign in button
                      state is RegisterLoadingState
                          ? LoadingOnWaiting(
                            color: defaultColor.withOpacity(0.8),
                            width: 200)
                          :DefaultButton(
                            color: defaultColor.withOpacity(0.8),
                            width: 200,
                            text: 'SIGN UP', onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                   
                                  }
                                }) 
               ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
