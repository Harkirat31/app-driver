import 'package:drivers/exception/Exceptions.dart/app_exceptions.dart';
import 'package:drivers/helper/loading/loading_screen.dart';
import 'package:drivers/service/api_service.dart';
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
                if (_email.text == null || _email.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter Email'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                if (_password.text == null || _password.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter Password'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                LoadingScreen().show(context: context, text: "Signing In...");
                ApiService().signIn(_email.text, _password.text).then((value) {
                  if (value) {
                    LoadingScreen().hide();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/init', (_) => false);
                  }
                }).catchError((error) {
                  LoadingScreen().hide();
                  if (error is WrongCredentials) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Wrong Credentials'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email is incorrect / Server Problem'),
                        duration: Duration(seconds: 3),
                      ),
                    );
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
