import 'package:drivers/model/driver_company.dart';
import 'package:flutter/foundation.dart';

class DriverCompanyProvider extends ChangeNotifier {
  final List<DriverCompany> _driverCompanyList = [];
  DateTime _selectedDate =  DateTime.now();
  int _selectedCompanyIndex = 0;
  List<DateTime> _futureDeliveryDates = [];
  void addDriverCompantList(List<DriverCompany> driverCompanies) {
    _driverCompanyList.addAll(driverCompanies);
    notifyListeners();
  }

  List<DriverCompany> get driverCompanies => _driverCompanyList;

  DateTime get selectedDate => _selectedDate;

  int get selectedCompanyIndex => _selectedCompanyIndex;

  List<DateTime> get futureDeliveryDates => _futureDeliveryDates;

  void updateData() {
    notifyListeners();
  }

  void updateDate(DateTime date){
    _selectedDate = date; 
     notifyListeners();
  }

  void updateFutureDeliveryDates(List<DateTime> dates){
    _futureDeliveryDates = dates;
  }

  void updateSelectedCompanyIndex(int index){
    _selectedCompanyIndex = index;
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
