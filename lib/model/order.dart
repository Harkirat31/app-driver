import 'package:drivers/model/location.dart';

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
  DeliveryStatus currentStatus;
  DateTime deliveryDate;
  String? specialInstructions;
  Priority priority;
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
    this.priority = Priority.Medium,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    DeliveryStatus? currentStatus;
    Priority? priority;
    if (json['currentStatus'] == "Assigned") {
      currentStatus = DeliveryStatus.Assigned;
    } else {
      currentStatus = DeliveryStatus.PathAssigned;
    }

    if (json['priority'] == "Low") {
      priority = Priority.Low;
    } else if (json['priority'] == "Medium") {
      priority = Priority.Medium;
    } else {
      priority = Priority.High;
    }

    return Order(
        address: json['address'],
        cphone: json['cphone'],
        cname: json["cname"],
        currentStatus: currentStatus,
        deliveryDate: DateTime.now(),
        specialInstructions: json['specialInstructions'],
        companyId: json['companyId'],
        assignedPathId: json['assignedPathId'],
        driverId: json['driverId'],
        driverName: json['driverName'],
        itemsDetail: json['itemsDetail'],
        location: json['location'],
        orderId: json['orderId'],
        orderNumber: json['orderNumber'],
        placeId: json['placeId'],
        priority: priority);
  }
}

Order o = Order(
  address: "address",
  cphone: "cphone",
  cname: "cname",
  currentStatus: DeliveryStatus.Accepted,
  deliveryDate: DateTime.now(),
  specialInstructions: "specialInstructions",
);

enum DeliveryStatus {
  NotAssigned,
  Assigned,
  PathAssigned,
  SentToDriver,
  OnTheWay,
  Accepted,
  Delivered,
  Picked,
  Returned,
}

enum Priority { High, Medium, Low }
