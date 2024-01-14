import 'package:flutter/material.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    // TODO: implement initState
    // if()
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
