
import 'package:drivers/helper/loading/loading_screen.dart';
import 'package:drivers/service/api_service.dart';
import 'package:flutter/material.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  String? password;
  late TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
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
                  label: Text("Email")),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 const SizedBox(
              height: 8,
              width: double.infinity,
            ),
             GestureDetector(
               onTap: () {
                 Navigator.of(context)
                        .pushNamedAndRemoveUntil('/signIn', (_) => false);
              },
              child: const Text("Sign In",style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue
              ),),
            ),
              ],
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
                LoadingScreen().show(context: context, text: "Please wait...");
                ApiService().resetPassword(_email.text,).then((value) {
                  if (value) {
                    LoadingScreen().hide();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reset Email Sent !!'),
                        duration: Duration(seconds: 6),
                      ),
                    );
                  }
                }).catchError((error) {
                  LoadingScreen().hide();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email is incorrect / Server Problem'),
                        duration: Duration(seconds: 4),
                      ),
                    );
                
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
              child: const Text("Send Reset Link"),
            )
          ],
        ),
      ),
    );
  }
}

