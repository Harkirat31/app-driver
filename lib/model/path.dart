import 'package:drivers/helper/dateHelper.dart';
import 'package:drivers/model/order.dart';

class Path {
  List<Order> path;
  String? companyId;
  DateTime dateOfPath;
  String? pathId;
  bool show;
  String? driverId;
  String? driverName;

  Path(
      {required this.path,
      this.pathId,
      required this.show,
      required this.dateOfPath,
      this.companyId,
      this.driverId,
      this.driverName});
  factory Path.fromJson(Map<String, dynamic> json) {
    List<dynamic> pathInJson = json['path'];
    List<Order> path = [];
    for (var element in pathInJson) {
      Order order = Order.fromJson(element);
      path.add(order);
    }
    return Path(
        path: path,
        pathId: json['pathId'],
        dateOfPath: getDateFromString(json['dateOfPath']),
        show: bool.parse(json['show']),
        companyId: json['companyId'],
        driverId: json['driverId'],
        driverName: json['driverName']);
  }
}
