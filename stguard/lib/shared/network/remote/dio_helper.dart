//import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:st_tracker/shared/components/constants.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com',
      receiveDataWhenStatusError: true,
    ));
  }

  static Map<String, Object> notificationMessage(
      {required String title, required String body,required String fcmToken}) {
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

  static Future<Response> sendNotification({
    required String title,
    required String body,
    required String receiverToken
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': fcmProjectToken
    };
    return await dio.post('https://fcm.googleapis.com/fcm/send',
        data: notificationMessage(fcmToken: receiverToken ,
            title: title, body: body));
  }
}
