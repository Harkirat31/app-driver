import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/service/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Init extends StatefulWidget {
  const Init({super.key});

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      if (value.getString("token") != null) {
        //dave FCM Token in db backend
        handleFCM(value.getString("token")!);
        // fetch data and populate Providers

        ApiService().getDriverCompanyList().then((value) {
          context.read<DriverCompanyProvider>().addDriverCompantList(value);
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/landing', (route) => false);
        }).onError((error, stackTrace) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/signIn', (route) => false);
        });
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/signIn', (route) => false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

Future<void> saveTokenToDatabase(String jwtToken) async {
  // Assume user is logged in for this example
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await ApiService().saveFCMToken(token, jwtToken);
    }
  } catch (e) {}
}

void handleFCM(String jwtToken) async {
  await saveTokenToDatabase(jwtToken);
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen((event) {
  //   print(event.data);
  // });
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }
