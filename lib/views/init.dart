import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/service/api_service.dart';
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
