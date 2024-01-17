import 'package:drivers/service/Exceptions.dart/spp_exceptions.dart';
import 'package:drivers/service/api_service.dart';
import 'package:drivers/views/landing.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? email;
  String? password;
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {
                ApiService()
                    .signIn("harkiratsingh.tu@gmail.com", "Password123!")
                    .then((value) {
                  if (value) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/landing', (_) => false);
                  }
                }).onError((error, stackTrace) {
                  if (error is WrongCredentials) {
                    print("Show Wrong Credential");
                  } else {
                    print("Show Wrong Credential");
                  }
                });
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: Colors.blue.shade600, // Background color
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 16), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Border radius
                  )),
              child: const Text("Sign In"),
            )
          ],
        ),
      ),
    );
  }
}
