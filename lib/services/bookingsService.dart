import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bookingsModel.dart';
import 'authService.dart';

class BookingService {
  static Future<List<Booking>> fetchAppointments() async {
    try {
      final res = await http
          .get(
            Uri.parse('${AuthService.baseUrl}/admin/appointments'),
            headers: AuthService.authHeaders,
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['appointments'] as List<dynamic>;
        return list.map((e) => Booking.fromJson(e)).toList();
      }
      throw Exception('Failed to load appointments (${res.statusCode})');
    } catch (e) {
      print('BookingService error: $e');
      rethrow;
    }
  }

  static Future<void> createAppointment(Map<String, dynamic> payload) async {
    try {
      final res = await http
          .post(
            Uri.parse('${AuthService.baseUrl}/admin/appointments'),
            headers: AuthService.authHeaders,
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception('Failed to create appointment (${res.statusCode})');
      }
    } catch (e) {
      print('BookingService create error: $e');
      rethrow;
    }
  }
}
