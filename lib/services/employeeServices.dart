import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/services/authService.dart';

// ── Model ──────────────────────────────────────────────────────────────────

class Employee {
  final String id;
  final String name;
  final String color;
  final String phone;
  final String? avatar;
  final String? shiftStart;
  final String? shiftEnd;
  final DateTime createdAt;

  Employee({
    required this.id,
    required this.name,
    required this.color,
    required this.phone,
    this.avatar,
    this.shiftStart,
    this.shiftEnd,
    required this.createdAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>? ?? {};
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#6366f1',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      shiftStart: meta['shift_start'],
      shiftEnd: meta['shift_end'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

// ── Service ────────────────────────────────────────────────────────────────

class EmployeeService {
  // 🔧 Change this to your Medusa server URL
  // static const String _baseUrl = 'http://10.0.2.2:9000';

  static Future<List<Employee>> fetchEmployees() async {
    final uri = Uri.parse('${AuthService.baseUrl}/admin/employees');

    try {
      final response = await http
          .get(uri, headers: AuthService.authHeaders)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final list = data['employees'] as List<dynamic>;
        return list.map((e) => Employee.fromJson(e)).toList();
      } else {
        print(response);
        throw Exception('Failed to load employees (${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      print('ERROR TYPE: ${e.runtimeType}');
      print('ERROR: $e');
      throw Exception('Failed to fetch: $e');
    }
  }

  static Future<void> deleteEmployee(String id) async {
    final uri = Uri.parse('${AuthService.baseUrl}/admin/employees/$id');
    final response = await http.delete(uri);
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete employee');
    }
  }
}
