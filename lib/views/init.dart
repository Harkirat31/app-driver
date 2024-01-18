import 'package:drivers/service/api_service.dart';
import 'package:flutter/material.dart';
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/landing', (route) => false);
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
