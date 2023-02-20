import 'package:flutter/material.dart';
import 'package:flutter_tap_payment/flutter_tap_payment.dart';
import 'package:st_tracker/modules/parent/recharge_success/recharge_success_screen.dart';
import 'package:st_tracker/shared/components/components.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TapPaymentScreen extends StatelessWidget {
  const TapPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment Tap'),
        ),
        body: TapPayment(
            apiKey: "sk_test_YRAryEcNpLxZuUh9CQ5JmFaW",
            redirectUrl: "http://your_website.com/redirect_url",
            postUrl: "http://your_website.com/post_url",
            paymentData: const {
              "amount": 10,
              "currency": "EGP",
              "threeDSecure": true,
              "save_card": true,
              "description": "Test Description",
              "statement_descriptor": "Sample",
              "reference": {"transaction": "txn_0001", "order": "ord_0001"},
              "receipt": {"email": false, "sms": true},
              "customer": {
                "first_name": "test",
                "middle_name": "test",
                "last_name": "test",
                "email": "test@test.com",
                "phone": {"country_code": "20", "number": "1229213236"}
              },
              // "merchant": {"id": ""},
              "source": {"id": "src_card"},
              // "destinations": {
              //   "destination": [
              //     {"id": "480593777", "amount": 2, "currency": "KWD"},
              //     {"id": "486374777", "amount": 3, "currency": "KWD"}
              //   ]
              // }
            },
            onSuccess: (Map params) async {
              print("onSuccess: $params");

            },
            onError: (error) {
              print("onError: $error");
            }));
  }
}
