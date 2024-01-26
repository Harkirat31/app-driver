import 'package:drivers/model/driver_company.dart';
import 'package:flutter/foundation.dart';

class DriverCompanyProvider extends ChangeNotifier {
  final List<DriverCompany> _driverCompanyList = [];
  void addDriverCompantList(List<DriverCompany> driverCompanies) {
    _driverCompanyList.addAll(driverCompanies);
    notifyListeners();
  }

  // UnmodifiableListView<DriverCompany> get driverCompanies =>
  //     UnmodifiableListView(_driverCompanyList);
  List<DriverCompany> get driverCompanies => _driverCompanyList;

  void updateData() {
    notifyListeners();
  }

  void logout() {
    _driverCompanyList.clear();
  }
}
