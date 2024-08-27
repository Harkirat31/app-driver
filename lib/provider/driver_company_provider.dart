import 'package:drivers/model/driver_company.dart';
import 'package:flutter/foundation.dart';

class DriverCompanyProvider extends ChangeNotifier {
  final List<DriverCompany> _driverCompanyList = [];
  DateTime _selectedDate =  DateTime.now();
  void addDriverCompantList(List<DriverCompany> driverCompanies) {
    _driverCompanyList.addAll(driverCompanies);
    notifyListeners();
  }

  // UnmodifiableListView<DriverCompany> get driverCompanies =>
  //     UnmodifiableListView(_driverCompanyList);
  List<DriverCompany> get driverCompanies => _driverCompanyList;

  DateTime get selectedDate => _selectedDate;

  void updateData() {
    notifyListeners();
  }

  void updateDate(DateTime date){
    _selectedDate = date; 
     notifyListeners();
  }


  void refresh(List<DriverCompany> driverCompanies) {
    _driverCompanyList.clear();
    _driverCompanyList.addAll(driverCompanies);
    notifyListeners();
  }

  void logout() {
    _driverCompanyList.clear();
  }
}
