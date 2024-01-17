import 'package:drivers/model/location.dart';
import 'package:drivers/model/path.dart';

class DriverCompany {
  List<Path>? paths;
  String email;
  bool isAutomaticallyTracked;
  String name;
  String phone;
  String? uid;
  String vehicleStyle;
  String? companyId;
  String? companyName;
  Location? companyLocation;
  Location? currentLocation;
  DriverCompany({
    this.paths,
    required this.email,
    required this.isAutomaticallyTracked,
    required this.name,
    required this.phone,
    this.uid,
    this.companyId,
    required this.vehicleStyle,
    this.currentLocation,
    this.companyName,
    this.companyLocation,
  });
  factory DriverCompany.fromJson(Map<String, dynamic> json) {
    return DriverCompany(
      email: json['email'],
      isAutomaticallyTracked: json['isAutomaticallyTracked'],
      currentLocation: Location.fromJson(json['currentLocation']),
      name: json['name'],
      phone: json['phone'],
      vehicleStyle: json['vehicleStyle'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyLocation: Location.fromJson(json['companyLocation']),
    );
  }
}
