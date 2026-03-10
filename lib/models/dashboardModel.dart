class Appointment {
  final String name;
  final String service;
  final String barber;
  final String time;
  final String duration;

  Appointment({
    required this.name,
    required this.service,
    required this.barber,
    required this.time,
    required this.duration,
  });

  // later, replace this with: factory Appointment.fromJson(Map<String, dynamic> json)
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      name: json['name'],
      service: json['service'],
      barber: json['barber'],
      time: json['time'],
      duration: json['duration'],
    );
  }
}

class DashboardData {
  final String shopName;
  final int revenue;
  final int customersToday;
  final int upcomingCount;
  final int revenueChange;
  final List<Appointment> appointments;

  DashboardData({
    required this.shopName,
    required this.revenue,
    required this.customersToday,
    required this.upcomingCount,
    required this.revenueChange,
    required this.appointments,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      shopName: json['shopName'],
      revenue: json['revenue'],
      customersToday: json['customersToday'],
      upcomingCount: json['upcomingCount'],
      revenueChange: json['revenueChange'],
      appointments: (json['appointments'] as List)
          .map((a) => Appointment.fromJson(a))
          .toList(),
    );
  }
}
