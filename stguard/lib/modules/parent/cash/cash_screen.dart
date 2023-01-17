import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/modules/parent/recharge_success/recharge_success_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CashScreen extends StatelessWidget {
  CashScreen({super.key});
  var codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    screen_width = MediaQuery.of(context).size.width;
    screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {
          if (state is RechargeSuccessState) {
            navigateAndFinish(
                context, RechargeSuccessScreen(amount: state.amount));
          } else if (state is RechargeErrorState) {
            ShowToast(message: state.error, state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Center(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/payment-method.png'),
                    width: screen_width * 0.4,
                    height: screen_width * 0.4,
                  ),
                  SizedBox(
                    height: screen_height * 0.05,
                  ),
                  DefaultFormField(
                      prefix: Icons.code_outlined,
                      isClickable: true,
                      controller: codeController,
                      type: TextInputType.text,
                      validate: (value) {},
                      label: "Reference Code"),
                  SizedBox(
                    height: screen_height * 0.03,
                  ),
                  state is RechargeLoadingState
                      ? Container(
                          height: screen_height * 0.07,
                          width: double.infinity,
                          
                          decoration: BoxDecoration(
                            color: defaultColor.withOpacity(0.8),
                            borderRadius: BorderRadiusDirectional.circular(10)),
                          child: Center(child: const CircularProgressIndicator(color: Colors.white,)))
                      : DefaultButton(
                          height: screen_height * 0.07,
                          text: 'Recharge',
                          onPressed: () => ParentCubit.get(context)
                              .cashRecharge(code: codeController.text),
                          color: defaultColor.withOpacity(0.8),
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
