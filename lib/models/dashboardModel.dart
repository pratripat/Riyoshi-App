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

class HourlyData {
  final String time;
  final int customers;

  HourlyData({required this.time, required this.customers});

  factory HourlyData.fromJson(Map<String, dynamic> json) {
    return HourlyData(
      time: json['time'] ?? '',
      customers: json['customers'] ?? 0,
    );
  }
}

class RevenueData {
  final String day;
  final int rev;

  RevenueData({required this.day, required this.rev});

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(day: json['day'] ?? '', rev: json['rev'] ?? 0);
  }
}

class DashboardData {
  final int todayRevenue;
  final int todayCount;
  final int avgTicket;
  final int yesterdayRevenue;
  final int weekSales;
  final int monthSales;
  final List<HourlyData> hourlyData;
  final List<RevenueData> revenueData;

  DashboardData({
    required this.todayRevenue,
    required this.todayCount,
    required this.avgTicket,
    required this.yesterdayRevenue,
    required this.weekSales,
    required this.monthSales,
    required this.hourlyData,
    required this.revenueData,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'];
    return DashboardData(
      todayRevenue: stats['todayRevenue'] ?? 0,
      todayCount: stats['todayCount'] ?? 0,
      avgTicket: stats['avgTicket'] ?? 0,
      yesterdayRevenue: stats['yesterdayRevenue'] ?? 0,
      weekSales: stats['weekSales'] ?? 0,
      monthSales: stats['monthSales'] ?? 0,
      hourlyData: (stats['hourlyData'] as List)
          .map((e) => HourlyData.fromJson(e))
          .toList(),
      revenueData: (stats['revenueData'] as List)
          .map((e) => RevenueData.fromJson(e))
          .toList(),
    );
  }
}
