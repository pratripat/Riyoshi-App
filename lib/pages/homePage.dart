import 'package:flutter/material.dart';
import 'package:myapp/pages/dashboard.dart';
import 'package:myapp/pages/bookingsPage.dart';
import 'package:myapp/pages/employeePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    BookingsPage(),
    Center(child: Text("Services Page")),
    DashboardPage(), // ← change this line
    EmployeesPage(),
    Center(child: Text("Customers Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Bookings",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.build), label: "Services"),

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Employees"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Customers"),
        ],
      ),
    );
  }
}
