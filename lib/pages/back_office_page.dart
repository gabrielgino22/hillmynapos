import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/collapsible_nav.dart';
import 'edit_services_page.dart';
import 'settings_page.dart';

class BackOfficePage extends StatefulWidget {
  const BackOfficePage({super.key});

  @override
  State<BackOfficePage> createState() => _BackOfficePageState();
}

class _BackOfficePageState extends State<BackOfficePage> {
  final int _pageIndex = 5; // Index for Back Office in navigation

  void _handleNavigation(int index) {
    if (index != _pageIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/shift');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/edit-services');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/receipts');
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/settings');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CollapsibleNav(
            selectedIndex: _pageIndex,
            onDestinationSelected: _handleNavigation,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(26, 0, 0, 0), // Fixed Color Issue
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Back Office',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.all(24),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    children: [
                      _buildMenuCard(
                        'Edit Services',
                        Icons.edit,
                        Colors.blue,
                        () => Navigator.pushReplacementNamed(
                            context, '/edit-services'),
                      ),
                      _buildMenuCard(
                        'Staff Management',
                        Icons.people,
                        Colors.orange,
                        () => Navigator.pushReplacementNamed(
                            context, '/staff-management'),
                      ),
                      _buildMenuCard(
                        'Reports',
                        Icons.bar_chart,
                        Colors.purple,
                        () =>
                            Navigator.pushReplacementNamed(context, '/reports'),
                      ),
                      _buildMenuCard(
                        'Settings',
                        Icons.settings,
                        Colors.grey,
                        () => Navigator.pushReplacementNamed(
                            context, '/settings'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: color,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
