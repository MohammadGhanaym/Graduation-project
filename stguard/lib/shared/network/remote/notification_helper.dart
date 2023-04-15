import 'dart:convert';
import 'package:http/http.dart';
import 'package:stguard/shared/components/constants.dart';
import 'package:http/http.dart' as http;

class NotificationHelper {
  static Map<String, Object> notificationMessage(
      {required String title, required String body, required String fcmToken}) {
    return {
      "to": fcmToken,
      "notification": {"title": title, "body": body, "sound": "default"},
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"}
    };
  }

  static Future<Response> sendNotification(
      {required String title,
      required String body,
      required String receiverToken}) async {
    return await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(notificationMessage(
            fcmToken: receiverToken, title: title, body: body)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': fcmProjectToken
        });
  }
}
