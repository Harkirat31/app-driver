import 'dart:convert';
import 'package:drivers/config.dart';
import 'package:drivers/service/Exceptions.dart/spp_exceptions.dart';
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
      }).onError((error, stackTrace) {
        if (error != null) {
          throw error;
        } else {
          throw GenericException();
        }
      });
    });
  }

  void getDriverCompanyList() {
    // http
    //     .post(Uri.parse('${BASE_URL}auth/signinDriver'),
    //         headers: {
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: jsonEncode({
    //           "email": "harkiratsingh.tu@gmail.com",
    //           "password": "Password123!"
    //         }))
    //     .then((value) {
    //   print(jsonDecode(value.body));
    //   return true;
    // }).onError((error, stackTrace) {
    //   print(error);
    //   return false;
    // });
    http
        .get(Uri.parse('${BASE_URL}driver/getDriver'), headers: {
          "Authorization":
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiI3eVBXVUd1bGE4VGZWY3RLOWN5VW5Lc3VxMWwyIiwiaWF0IjoxNzA1MzQ3MTI3LCJleHAiOjE3MDc5MzkxMjd9.Dw7CBJwiyFeMvyuxRWYpzG54-QnWhJh3VlgKFe0gZBM"
        })
        .then(
            (value) => {print(jsonDecode(value.body) as Map<String, dynamic>)})
        .onError((error, stackTrace) => {print(error)});

    // List<dynamic> pathsInJson = json['paths'];
    // List<Path> paths = [];
    // for (var element in pathsInJson) {
    //   Path path = Path.fromJson(element);
    //   paths.add(path);
    // }
  }
}
