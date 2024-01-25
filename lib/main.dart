import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/views/init.dart';
import 'package:drivers/views/landing.dart';
import 'package:drivers/views/order_info.dart';
import 'package:drivers/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return DriverCompanyProvider();
      },
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            color: Colors.blue,
          ),
        ),
        routes: {
          '/landing': (context) => const Landing(),
          '/signIn': (context) => const SignIn(),
          '/init': (context) => const Init(),
          '/orderInfo': (context) => const OrderInfo()
        },
        home: const Init());
  }
}
