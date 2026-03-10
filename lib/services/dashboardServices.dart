import '../models/dashboardModel.dart';

class DashboardService {
  Future<DashboardData> fetchDashboard() async {
    // ---- HARDCODED FOR NOW ----
    // later, replace this whole block with:
    //
    // final response = await http.get(Uri.parse('https://yourapi.com/dashboard'));
    // final json = jsonDecode(response.body);
    // return DashboardData.fromJson(json);

    await Future.delayed(
      Duration(milliseconds: 500),
    ); // simulates network delay

    final hardcoded = {
      'shopName': 'Royal Cuts Salon',
      'revenue': 6200,
      'customersToday': 14,
      'upcomingCount': 3,
      'revenueChange': 18,
      'appointments': [
        {
          'name': 'Priya Patel',
          'service': 'Hair Spa',
          'barber': 'Vikram',
          'time': '10:30',
          'duration': '60 min',
        },
        {
          'name': 'Suresh Reddy',
          'service': 'Haircut',
          'barber': 'Ravi',
          'time': '11:00',
          'duration': '30 min',
        },
        {
          'name': 'Amir Khan',
          'service': 'Beard Trim',
          'barber': 'Vikram',
          'time': '11:45',
          'duration': '20 min',
        },
      ],
    };

    return DashboardData.fromJson(hardcoded);
  }
}
