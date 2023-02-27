import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/layout/canteen/Canteen_home_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/components/constants.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class AddCanteenScreen extends StatelessWidget {
  AddCanteenScreen({super.key});
  TextEditingController CanteenController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Community'),
        centerTitle: true,
      ),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {
          if (state is GetCanteenPathSuccessState) {
            navigateAndFinish(context, CanteenHomeScreen());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screen_height * 0.05,
                  horizontal: screen_width * 0.1),
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/canteen.png'),
                  ),
                  SizedBox(
                    height: screen_height * 0.05,
                  ),
                  DefaultFormField(
                      controller: CanteenController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'ID must not be empty';
                        }
                        return null;
                      },
                      label: 'Canteen ID'),
                  SizedBox(
                    height: screen_height * 0.05,
                  ),
                  state is AddCanteenLoadingState
                      ? LoadingOnWaiting(
                          color: defaultColor.withOpacity(0.8),
                          height: screen_height * 0.06,
                        )
                      : DefaultButton(
                          text: 'Confirm',
                          height: screen_height * 0.06,
                          color: defaultColor.withOpacity(0.8),
                          onPressed: () {
                            CanteenCubit.get(context)
                                .addCanteen(CanteenController.text);
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
