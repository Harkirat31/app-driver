import 'package:drivers/model/location.dart';
import 'package:drivers/model/path.dart';

class Driver {
  List<Path> paths;
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
  Driver({
    required this.paths,
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
  factory Driver.fromJson(Map<String, dynamic> json) {
    List<dynamic> pathsInJson = json['paths'];
    List<Path> paths = [];
    for (var element in pathsInJson) {
      Path path = Path.fromJson(element);
      paths.add(path);
    }
    return Driver(
      email: json['email'],
      isAutomaticallyTracked: json['isAutomaticallyTracked'],
      currentLocation: Location.fromJson(json['currentLocation']),
      name: json['name'],
      paths: paths,
      phone: json['phone'],
      vehicleStyle: json['vehicleStyle'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      companyLocation: Location.fromJson(json['companyLocation']),
    );
  }
}
