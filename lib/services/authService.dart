import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://riyoshi-crm.zeabur.app';

  static String? _token;
  static String? get token => _token;

  static Map<String, String> get authHeaders => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  static Future<bool> login(String email, String password) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/user/emailpass'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _token = data['token']; // stores token in memory
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static void logout() {
    _token = null;
  }
}
