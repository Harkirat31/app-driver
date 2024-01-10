import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    // TODO: implement initState
    var x;
    super.initState();
    http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')).then(
        (value) => {
              x = jsonDecode(value.body) as Map<String, dynamic>,
              print(x['userId'])
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: const Column(
        children: [Text("data")],
      ),
    );
  }
}
