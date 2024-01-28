import 'dart:convert';
import 'package:drivers/config.dart';
import 'package:drivers/exception/Exceptions.dart/app_exceptions.dart';
import 'package:drivers/model/driver_company.dart';
import 'package:drivers/model/order.dart';
import 'package:drivers/model/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._sharedInstance();
  static final ApiService _shared = ApiService._sharedInstance();
  factory ApiService() => _shared;

  Future<bool> signIn(String email, String password) {
    return Future(() {
      return http
          .post(Uri.parse('${BASE_URL}auth/signinDriver'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({"email": email, "password": password}))
          .then((value) async {
        Map<String, dynamic> result =
            jsonDecode(value.body) as Map<String, dynamic>;
        if (result['token'] != null) {
          try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("token", result['token']);
          } catch (error) {
            throw GenericException();
          }
          return true;
        } else {
          //print(result['err']);
          if (result['err'] == 2) {
            throw WrongCredentials();
          } else {
            throw GenericException();
          }
        }
      }).catchError((error, stackTrace) {
        if (error != null) {
          throw error;
        } else {
          throw GenericException();
        }
      });
    });
  }

  Future<List<DriverCompany>> getDriverCompanyList() {
    return Future(() {
      return SharedPreferences.getInstance().then((value) {
        String? token = value.getString("token");
        if (token != null) {
          return http.get(
            Uri.parse('${BASE_URL}driver/getDriver'),
            headers: {
              "Authorization": "Bearer $token",
            },
          ).then((value) {
            Map<String, dynamic> dataMap =
                jsonDecode(value.body) as Map<String, dynamic>;
            List<DriverCompany> allDriverCompany = [];
            Map<String, Order> allOrders = {};
            Map<String, List<Path>> allPaths = {};
            var arrayDriverCompany = dataMap['driverCompanyList'] as List;
            var paths = dataMap['paths'] as List;
            var orders = dataMap['orders'] as List;

            for (Map<String, dynamic> orderJson in orders) {
              Order order = Order.fromJson(orderJson);
              allOrders[order.orderId!] = order;
            }

            for (Map<String, dynamic> pathJson in paths) {
              Path path = Path.fromJson(pathJson);
              List<Order> orders = [];
              List<dynamic> ordersInPath = pathJson['path'] as List<dynamic>;
              for (String orderId in ordersInPath) {
                orders.add(allOrders[orderId]!);
              }
              path.path = orders;
              if (allPaths.containsKey(path.companyId!)) {
                allPaths[path.companyId!]!.add(path);
              } else {
                allPaths[path.companyId!] = [path];
              }
            }

            for (Map<String, dynamic> element in arrayDriverCompany) {
              DriverCompany driverCompany = DriverCompany.fromJson(element);
              driverCompany.paths = allPaths[driverCompany.companyId!];
              allDriverCompany.add(driverCompany);
            }
            return allDriverCompany;
          }).catchError((error) {
            if (error != null) {
              throw error;
            } else {
              throw GenericException();
            }
          });
        } else {
          throw UserNotLogin();
        }
      }).onError((error, stackTrace) {
        if (error != null) {
          throw error;
        }
        throw GenericException();
      });
    });
  }

  Future<bool> markDelivered(String orderId) {
    return Future(() {
      return SharedPreferences.getInstance().then((value) {
        String? token = value.getString("token");
        if (token != null) {
          return http
              .post(Uri.parse('${BASE_URL}driver/updateOrderStatus'),
                  headers: {
                    "Authorization": "Bearer $token",
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(
                      {"orderId": orderId, "currentStatus": "Delivered"}))
              .then((value) {
            Map<String, dynamic> result =
                jsonDecode(value.body) as Map<String, dynamic>;
            if (result['isUpdated'] == true) {
              return true;
            } else {
              throw GenericException();
            }
          }).onError((error, stackTrace) {
            if (error != null) {
              throw error;
            } else {
              throw GenericException();
            }
          });
        } else {
          throw UserNotLogin();
        }
      }).onError((error, stackTrace) {
        if (error != null) {
          throw error;
        }
        throw GenericException();
      });
    });
  }
}
