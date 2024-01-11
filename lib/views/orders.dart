import 'package:drivers/model/order.dart';
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
    //DateTime d = DateTime.parse("2024-01-10T00:00:00.00Z");
    DateTime d = DateTime.now();

    String test =
        '[{"cphone": "647-767-5084","itemsDetail": "Jungle Combo w Pool","orderNumber": "3","address": "128 Wigmori Drive, Toronto","cname": "Cesar Gomes","placeId": "ChIJlZVf-JTN1IkRopkyQE-1mTA","cemail": "cgomes.dc@gmail.com","priority": "Medium","companyId": "9CaZ0g3gXTWOLCUsJ4dQlVS5VqB2","specialInstructions": "grass","location": {"lng": -79.3154564,"lat": 43.7310694},"deliveryDate": "2024-02-20T00:00:00.000Z","assignedPathId": "Zjf7vGOwt2w0yfwvC7OD","driverId": "7yPWUGula8TfVctK9cyUnKsuq1l2","currentStatus": "SentToDriver","driverName": "harry","orderId": "3rzKctxG5YAqwLvGjRa5"}]';
    try {
      Order o = Order.fromJson(jsonDecode(test)[0]);
      print(o.address);
    } catch (e) {
      print(e);
    }
    // print(d.toUtc());
    // var x;
    super.initState();
    // http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1')).then(
    //     (value) => {
    //           x = jsonDecode(value.body) as Map<String, dynamic>,
    //           print(x['userId'])
    //         });
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
