import 'package:flutter/material.dart';
import 'package:tenant_app/screens/update_contact_screen.dart';
import 'package:tenant_app/theme/app_colors.dart';
import 'rent_status_screen.dart';
import 'maintenance_form_screen.dart';
import 'maintenance_history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RentStatusScreen(),
    const MaintenanceRequestScreen(),
    // const MaintenanceHistoryScreen(),
    // const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Rent Status',
    'Submit Request',
    'Maintenance History',
    'Profile',
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Rent'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Request'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          ),
        ],
      ),
    );
  }
}