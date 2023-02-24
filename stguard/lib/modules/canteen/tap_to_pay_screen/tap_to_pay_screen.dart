import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/cubit/canteen_home.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class TapPayScreen extends StatelessWidget {
  const TapPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
              child: state is PaymentLoadingState
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is StartListeningBuyerDataState)
                          Text(
                            'Tap to Pay',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: defaultColor, fontWeight: FontWeight.w700),
                          ),
                        if (state is PaymentSuccessState)
                          Image(
                              image: state is PaymentSuccessState
                                  ? const AssetImage(
                                      'assets/images/check-mark.png')
                                  : const AssetImage(
                                      'assets/images/error.png')),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state is PaymentErrorState ||
                            state is SomethingWentWrongState)
                          const Text('Something Went Wrong'),
                        if (state is IDDeactivatedState)
                          const Text('ID is Deactivated'),
                        if (state is SpendingLimitExceededState)
                          const Text('Daily spending limit exceeded'),
                        if (state is ProductsContainAllergensState)
                          const Text('One or more products contain allergens'),
                        if (state is NotEnoughBalanceState)
                          const Text('Not Enough Balance'),
                        if (state is StartListeningBuyerDataState)
                          Text(
                            CanteenCubit.get(context)
                                .totalPrice
                                .toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        
                        if (state is PaymentErrorState ||
                            state is PaymentSuccessState)
                          DefaultButton(
                            text: 'Done',
                            onPressed: () =>
                                navigateAndFinish(context, CanteenHome()),
                          ),
                        if (state is StartListeningBuyerDataState)
                        const SizedBox(
                          width: 30,
                        ),
                ],
                    ));
        },
      ),
    );
  }
}
