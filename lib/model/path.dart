import 'package:drivers/helper/dateHelper.dart';
import 'package:drivers/model/order.dart';

class Path {
  List<Order>? path;
  String? companyId;
  DateTime? dateOfPath;
  String? pathId;
  bool? show;
  String? driverId;
  String? driverName;
  bool? isAcceptedByDriver;
  Path(
      {this.path,
      this.pathId,
      this.show,
      this.dateOfPath,
      this.companyId,
      this.driverId,
      this.driverName,
      this.isAcceptedByDriver});
  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
        pathId: json['pathId'],
        dateOfPath: getDateFromString(json['dateOfPath']),
        //show: bool.parse(json['show']),
        companyId: json['companyId'],
        driverId: json['driverId'],
        driverName: json['driverName'],
        isAcceptedByDriver:  json['isAcceptedByDriver']
        );
  }
}
