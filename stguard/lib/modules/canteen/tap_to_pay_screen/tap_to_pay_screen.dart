import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:st_tracker/layout/canteen/canteen_home_screen.dart';
import 'package:st_tracker/layout/canteen/cubit/cubit.dart';
import 'package:st_tracker/layout/canteen/cubit/states.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class TapPayScreen extends StatelessWidget {
  const TapPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              CanteenCubit.get(context).cancelBuyerListener();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: BlocConsumer<CanteenCubit, CanteenStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
              child: state is PaymentLoadingState
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state is StartListeningBuyerDataState)
                            Text(
                              'Tap to Pay',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(
                                      color: defaultColor,
                                      fontWeight: FontWeight.w700),
                            ),
                          if (state is PaymentSuccessState)
                            const Image(
                                width: 150,
                                height: 150,
                                color: defaultColor,
                                image:
                                    AssetImage('assets/images/check-mark.png')),
                          if (state is PaymentErrorState)
                            const Image(
                                width: 150,
                                height: 150,
                                color: Colors.red,
                                image: AssetImage('assets/images/error.png')),
                          const SizedBox(
                            height: 20,
                          ),
                          if (state is PaymentErrorState ||
                              state is PaymentSuccessState)
                            Container(
                              height: 200,
                              child: Column(
                                children: [
                                  if (state is PaymentSuccessState)
                                    Text(
                                      'Transaction Success',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: defaultColor),
                                    )
                                  else if (state is PaymentErrorState)
                                    Text(
                                      'Transaction Failed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: Colors.redAccent),
                                    ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  if (state is PaymentErrorState)
                                    Text(
                                      CanteenCubit.get(context).result == null
                                          ? 'Something Went Wrong'
                                          : CanteenCubit.get(context).result!,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(color: Colors.red),
                                    ),
                                ],
                              ),
                            ),
                          if (state is StartListeningBuyerDataState)
                            Text(
                              CanteenCubit.get(context)
                                  .totalPrice
                                  .toStringAsFixed(2),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          const SizedBox(
                            height: 150,
                          ),
                          if (state is PaymentErrorState ||
                              state is PaymentSuccessState)
                            DefaultButton(
                              text: 'Done',
                              onPressed: () {
                                CanteenCubit.get(context).getCanteenDetails();
                                CanteenCubit.get(context)
                                    .cancelSelectedProducts();
                                CanteenCubit.get(context).resetResult();
                                navigateAndFinish(context, const CanteenHomeScreen());
                              },
                            ),
                          if (state is StartListeningBuyerDataState)
                           Container(
  height: 250,
  width: 250,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: RadialGradient(
      center: Alignment.center,
      colors: [
        Colors.blueAccent,
        Colors.blueAccent,
        Colors.blueAccent,
        Colors.blueAccent.withOpacity(0.9),
         Colors.blueAccent.withOpacity(0.8),
        Colors.blueAccent.withOpacity(0.8),
        Colors.blueAccent.withOpacity(0.8),
         Colors.blueAccent.withOpacity(0.7),
      ],
      stops: const [0.0,0.1, 0.2,0.3, 0.4, 0.6, 0.8, 1.0],
    ),
  ),
)


                        ],
                      ),
                    ));
        },
      ),
    );
  }
}
