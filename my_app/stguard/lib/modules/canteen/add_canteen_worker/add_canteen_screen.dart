import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stguard/layout/canteen/cubit/cubit.dart';
import 'package:stguard/layout/canteen/cubit/states.dart';
import 'package:stguard/layout/canteen/Canteen_home_screen.dart';
import 'package:stguard/shared/components/components.dart';
import 'package:stguard/shared/styles/themes.dart';

class AddCanteenScreen extends StatelessWidget {
  AddCanteenScreen({super.key});
  TextEditingController CanteenController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Join Community'),
        centerTitle: true,
      ),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {
          if (state is GetCanteenPathSuccessState) {
            navigateAndFinish(context, const CanteenHomeScreen());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                  alignment: AlignmentDirectional.center,
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Theme.of(context).primaryColor),
                  child: const Image(
                    width: 280,
                    height: 280,
                    image: AssetImage('assets/images/canteen.png'),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      DefaultFormField(
                          controller: CanteenController,
                          type: TextInputType.text,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'ID must not be empty';
                            }
                            return null;
                          },
                          label: 'Canteen Worker ID'),
                      const SizedBox(
                        height: 50,
                      ),
                      DefaultButton(
                              text: 'Confirm',
                              height: 55,
                              showCircularProgressIndicator: state is AddCanteenLoadingState,
                              color: defaultColor.withOpacity(0.8),
                              onPressed: () {
                                CanteenCubit.get(context)
                                    .addCanteen(CanteenController.text);
                              },
                            ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
