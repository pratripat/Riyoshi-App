import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dashboardModel.dart';
import 'authService.dart';

class DashboardService {
  static Future<DashboardData> fetchDashboard() async {
    try {
      final res = await http
          .get(
            Uri.parse('${AuthService.baseUrl}/admin/stats'),
            headers: AuthService.authHeaders,
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return DashboardData.fromJson(data);
      }
      throw Exception('Failed to load dashboard (${res.statusCode})');
    } catch (e) {
      print('DashboardService error: $e');
      rethrow;
    }
  }
}
