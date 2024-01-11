import 'package:drivers/model/location.dart';
import 'dart:convert';

class Order {
  String? companyId;
  String? orderId;
  String? assignedPathId;
  String? orderNumber;
  String? itemsDetail;
  String? cemail;
  String address;
  String cphone;
  String cname;
  Location? location;
  String? placeId;
  String? driverId;
  String? driverName;
  String currentStatus;
  DateTime deliveryDate;
  String? specialInstructions;
  String priority;
  Order({
    this.companyId,
    this.orderId,
    this.assignedPathId,
    this.orderNumber,
    this.itemsDetail,
    this.location,
    this.placeId,
    this.driverId,
    this.driverName,
    required this.address,
    required this.cphone,
    required this.cname,
    required this.currentStatus,
    required this.deliveryDate,
    this.specialInstructions,
    this.priority = "Medium",
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    DateTime getDateFromString(String date) {
      DateTime d = DateTime.parse(date);
      return d;
    }

    return Order(
        address: json['address'],
        cphone: json['cphone'],
        cname: json["cname"],
        currentStatus: json['currentStatus'],
        deliveryDate: getDateFromString(json['deliveryDate']),
        specialInstructions: json['specialInstructions'],
        companyId: json['companyId'],
        assignedPathId: json['assignedPathId'],
        driverId: json['driverId'],
        driverName: json['driverName'],
        itemsDetail: json['itemsDetail'],
        location: Location.fromJson(json['location']),
        orderId: json['orderId'],
        orderNumber: json['orderNumber'],
        placeId: json['placeId'],
        priority: json['priority']);
  }
}

// enum DeliveryStatus {
//   NotAssigned,
//   Assigned,
//   PathAssigned,
//   SentToDriver,
//   OnTheWay,
//   Accepted,
//   Delivered,
//   Picked,
//   Returned,
// }

// enum Priority { High, Medium, Low }
