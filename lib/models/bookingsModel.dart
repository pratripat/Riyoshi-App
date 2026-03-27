class Booking {
  final String id;
  final String customerName;
  final String service;
  final String phone;
  final String employeeId;
  final DateTime start;
  final DateTime end;
  final String status;
  final int? totalPrice;

  Booking({
    required this.id,
    required this.customerName,
    required this.service,
    required this.phone,
    required this.employeeId,
    required this.start,
    required this.end,
    required this.status,
    this.totalPrice,
  });

  int get durationMinutes => end.difference(start).inMinutes;

  // maps "scheduled" → "confirmed", "canceled" → "cancelled"
  String get normalizedStatus {
    switch (status) {
      case 'scheduled':
        return 'confirmed';
      case 'canceled':
        return 'cancelled';
      default:
        return status;
    }
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    final meta = json['metadata'] as Map<String, dynamic>? ?? {};
    return Booking(
      id: json['id'] ?? '',
      customerName: meta['customer_name'] ?? 'Unknown',
      service: meta['service_name'] ?? 'Unknown Service',
      phone: meta['customer_phone'] ?? '',
      employeeId: json['employee_id'] ?? '',
      // API returns UTC — convert to local time
      start: DateTime.parse(json['start_time']).toLocal(),
      end: DateTime.parse(json['end_time']).toLocal(),
      status: json['status'] ?? 'scheduled',
      totalPrice: meta['total_price'] != null
          ? (meta['total_price'] as num).toInt()
          : null,
    );
  }
}
