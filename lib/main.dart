import 'package:drivers/firebase_options.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/views/forgot_password.dart';
import 'package:drivers/views/init.dart';
import 'package:drivers/views/landing.dart';
import 'package:drivers/views/map_view.dart';
import 'package:drivers/views/order_info.dart';
import 'package:drivers/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return DriverCompanyProvider();
      },
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Deliveries For Drivers',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              color:Colors.blue,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        routes: {
          '/landing': (context) => const Landing(),
          '/signIn': (context) => const SignIn(),
          '/init': (context) =>  const Init(),
          '/orderInfo': (context) => const OrderInfo(),
          '/mapView': (context) => PathMapView(),
          '/forgot':(context) => const ForgotPassword()
        },
        home: const Init());
  }
}
