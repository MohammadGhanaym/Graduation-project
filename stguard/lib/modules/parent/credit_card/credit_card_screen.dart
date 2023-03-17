import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:st_tracker/layout/parent/cubit/cubit.dart';
import 'package:st_tracker/layout/parent/cubit/states.dart';
import 'package:st_tracker/modules/parent/recharge_success/recharge_success_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:st_tracker/shared/styles/Themes.dart';

class CreditCardScreen extends StatelessWidget {
  final GlobalKey<FormState> creditCardFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> rechargeFormKey = GlobalKey<FormState>();
  final rechargeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const ImageIcon(
              AssetImage('assets/images/x.png'),
              color: defaultColor,
              size: 18,
            )),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Recharge', style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
        elevation: 0,
        bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 1), child: Divider()),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<ParentCubit, ParentStates>(
        listener: (context, state) {
          if (state is UpdateBalanceSuccess) {
            navigateAndFinish(context, RechargeStatusScreen(amount: rechargeController.text, status: 'Success',
            statusImage: 'check-mark',));
          } else if (state is UpdateBalanceError) 
          {
            navigateAndFinish(context, RechargeStatusScreen(amount: rechargeController.text, status: 'Failed',
            statusImage: 'error',));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              CreditCardWidget(
                cardNumber: ParentCubit.get(context).cardNumber,
                expiryDate: ParentCubit.get(context).expiryDate,
                cardHolderName: ParentCubit.get(context).cardHolderName,
                cvvCode: ParentCubit.get(context).cvvCode,
                showBackView: ParentCubit.get(context).isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {
                  print(creditCardBrand.brandName);
                },
                customCardTypeIcons: <CustomCardTypeIcon>[
                  CustomCardTypeIcon(
                    cardType: CardType.mastercard,
                    cardImage: Image.asset(
                      'assets/images/mastercard.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                  CustomCardTypeIcon(
                    cardType: CardType.visa,
                    cardImage: Image.asset(
                      'assets/images/visa.png',
                      height: 48,
                      width: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: creditCardFormKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: ParentCubit.get(context).cardNumber,
                        cvvCode: ParentCubit.get(context).cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: ParentCubit.get(context).cardHolderName,
                        expiryDate: ParentCubit.get(context).expiryDate,
                        themeColor: Colors.blue,
                        textColor: Colors.black54,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: const TextStyle(color: Colors.black54),
                          labelStyle: const TextStyle(color: Colors.black54),
                          focusedBorder: ParentCubit.get(context).border,
                          enabledBorder: ParentCubit.get(context).border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black54),
                          labelStyle: const TextStyle(color: Colors.black54),
                          focusedBorder: ParentCubit.get(context).border,
                          enabledBorder: ParentCubit.get(context).border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black54),
                          labelStyle: const TextStyle(color: Colors.black54),
                          focusedBorder: ParentCubit.get(context).border,
                          enabledBorder: ParentCubit.get(context).border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: const TextStyle(color: Colors.black54),
                          labelStyle: const TextStyle(color: Colors.black54),
                          focusedBorder: ParentCubit.get(context).border,
                          enabledBorder: ParentCubit.get(context).border,
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange:
                            ParentCubit.get(context).onCreditCardModelChange,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        margin:
                            const EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: Form(
                          key: rechargeFormKey,
                          child: TextFormField(
                            controller: rechargeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(color: Colors.black54),
                              labelStyle:
                                  const TextStyle(color: Colors.black54),
                              focusedBorder: ParentCubit.get(context).border,
                              enabledBorder: ParentCubit.get(context).border,
                              labelText: 'Recharge Amount',
                              hintText: 'Amount',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Recharge amount must not be empty';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid amount';
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      state is UpdateBalanceLoading?
                      LoadingOnWaiting(width: 280,
                      color: defaultColor.withOpacity(0.8),):
                      DefaultButton(
                        width: 280,
                        text: 'Recharge',
                        color: defaultColor.withOpacity(0.8),
                        onPressed: () {
                          if (creditCardFormKey.currentState!.validate()) {
                            if (rechargeFormKey.currentState!.validate()) {
                              ParentCubit.get(context).updateBalance(
                                  double.parse(rechargeController.text));
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
