import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/modules/login/cubit/cubit.dart';
import 'package:stguard/modules/login/cubit/states.dart';
import 'package:stguard/shared/components/components.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is SendPasswordResetEmailSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Password reset email sent!"),
                      duration: Duration(seconds: 3),
                    ));
            _emailController.clear();
          } else if (state is SendPasswordResetEmailErrorState) 
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error: ${state.error}"),
                      duration: const Duration(seconds: 3),
                    ));
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultFormField(controller: _emailController, type: TextInputType.text,
                   validate: (value) {
                      if (value!.isEmpty) {
                        return "Email can't be empty";
                      }
                      return null;
                    }, label: 'Email')
                  ,
                  const SizedBox(height: 16.0),
                  LoginCubit.get(context).isLoading
                      ? const CircularProgressIndicator()
                      : DefaultButton(
                          text: 'Reset Password',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              LoginCubit.get(context).changeLoading(true);
                              LoginCubit.get(context)
                                  .forgotPassword(_emailController.text);
                            }
                          },
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


