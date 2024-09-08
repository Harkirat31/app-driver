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

  Future<void> launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    // canLaunchUrl(phoneUri).then((value){
    //   print(value);
    // }).catchError((error){
    //    print("Printing Error :");
    //    print(error);
    // });
    if (Platform.isAndroid) {
      await launchUrl(phoneUri);
    } else {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    }
  }

  Widget orderDetailRow(String key,String value,[Widget? widget]) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Wrap(
        children: [
           Text(
            "$key : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          widget??Text(value),
        ],
      ),
    );
  }

  Widget getSpacing(){
    return   SizedBox(height: 1,child: Container(color: Colors.grey,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 16, // Set the desired font size here
            color: Colors.black,
             // You can also set other text properties
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                orderDetailRow("Date",order!.deliveryDate.toString().substring(0, 11)),
               getSpacing(),
                orderDetailRow("Order Id",order!.orderNumber ?? "N/A" ),
                getSpacing(),
                orderDetailRow("Name", order!.cname),
                getSpacing(),
                orderDetailRow("Phone", order!.cphone,),
                getSpacing(),
                orderDetailRow("Address", order!.address),
                getSpacing(),
                orderDetailRow("Priority", order!.priority),
                getSpacing(),
                orderDetailRow("Details",order!.itemsDetail ?? "No details provided" ),
                getSpacing(),
                orderDetailRow("Instructions",order!.specialInstructions ?? "No instructions" ),
                getSpacing(),
                order!.currentStatus != "Delivered"
                    ? Center(
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                LoadingScreen().show(
                                    context: context, text: "Please Wait ..");
                                ApiService()
                                    .markDelivered(order!.orderId!)
                                    .then((value) {
                                  LoadingScreen().hide();
                                }).onError((error, stackTrace) {
                                  LoadingScreen().hide();
                                });
                                order!.currentStatus = "Delivered";
                                context
                                    .read<DriverCompanyProvider>()
                                    .updateData();
                              });
                            },
                            child: const Text("Mark as Delivered")))
                    : orderDetailRow(
                        "Current Status",
                        "Delivered",
                        const Text(
                          "Delivered",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        )),
                     
                Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (order!.location != null) {
                            await launchGoogleMaps(
                                order!.location!.lat, order!.location!.lng);
                          }
                        },
                        child: const Text("Open Maps Navigation"))),
                Center(
                    child: ElevatedButton(
                        onPressed: () {
                          launchPhoneDialer(order!.cphone);
                        },
                        child: const Text("Call"))),
              ]),
        ),
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
