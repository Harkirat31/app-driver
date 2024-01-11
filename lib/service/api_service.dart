class ApiService {
  ApiService._sharedInstance();
  static final ApiService _shared = ApiService._sharedInstance();
  factory ApiService() => _shared;

  Future<bool> signIn(String email, String password) {
    return Future.delayed(const Duration(seconds: 5), () {
      return true;
    });
  }
}
