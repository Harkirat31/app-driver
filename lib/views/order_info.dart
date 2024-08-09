import 'dart:io';

import 'package:drivers/helper/loading/loading_screen.dart';
import 'package:drivers/model/order.dart';
import 'package:drivers/provider/driver_company_provider.dart';
import 'package:drivers/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderInfo extends StatefulWidget {
  const OrderInfo({super.key});

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  Order? order;

  @override
  void didChangeDependencies() {
    order = ModalRoute.of(context)?.settings.arguments as Order;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
            children: [
              const Text(
                "Date : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.deliveryDate.toString().substring(0, 11)),
            ],
          ),
          Wrap(
            children: [
              const Text(
                "Order Id : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.orderNumber ?? "N/A"),
            ],
          ),
          Wrap(
            children: [
              const Text(
                "Name : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.cname),
            ],
          ),
          Wrap(
            children: [
              const Text(
                "Address : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.address),
            ],
          ),
          Wrap(
            children: [
              const Text(
                "Priority : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.priority),
            ],
          ),
          Wrap(
            children: [
              const Text(
                "Details : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.itemsDetail ?? "No details provided"),
            ],
          ),
          Wrap(
            children: [
              const Text(
                "Instructions : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(order!.specialInstructions ?? "No instructions"),
            ],
          ),
          order!.currentStatus != "Delivered"
              ? Center(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          LoadingScreen()
                              .show(context: context, text: "Please Wait ..");
                          ApiService()
                              .markDelivered(order!.orderId!)
                              .then((value) {
                            LoadingScreen().hide();
                          }).onError((error, stackTrace) {
                            LoadingScreen().hide();
                          });
                          order!.currentStatus = "Delivered";
                          context.read<DriverCompanyProvider>().updateData();
                        });
                      },
                      child: const Text("Mark as Delivered")))
              : const Wrap(
                  children: [
                    Text(
                      "Current Status : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Delivered",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
          Center(
              child: ElevatedButton(
                  onPressed: () async {
                    if (order!.location != null) {
                      await launchGoogleMaps(
                          order!.location!.lat, order!.location!.lng);
                    }
                  },
                  child: const Text("Open Google Maps Navigation"))),
        ]),
      ),
    );
  }

  Future<void> launchGoogleMaps(double lat, double lng) async {
    double latitude = lat;
    double longitude = lng;
    Uri uri;
    if (Platform.isAndroid) {
      // Use geo: scheme for Android
      uri = Uri(
        scheme: 'geo',
        host: '0,0',
        queryParameters: {'q': '$latitude,$longitude'},
      );
    } else if (Platform.isIOS) {
      // First, try to open Google Maps if it's installed
      uri = Uri.parse('comgooglemaps://?q=$latitude,$longitude');

      // If Google Maps is not installed, fall back to Apple Maps
      if (!await canLaunchUrl(uri)) {
        uri = Uri.parse('maps://?q=$latitude,$longitude');
      }
    } else {
      throw 'Unsupported platform';
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }
}
