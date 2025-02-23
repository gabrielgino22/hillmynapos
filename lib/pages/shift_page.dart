import 'package:flutter/material.dart';
import '../widgets/nav_rail.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  final int _pageIndex = 1; // Index for Shift page

  void _handleNavigation(int index) {
    if (index != _pageIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/');
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
        case 5:
          Navigator.pushReplacementNamed(context, '/back-office');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavRail(
            selectedIndex: _pageIndex,
            onDestinationSelected: _handleNavigation,
          ),
          Expanded(
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Shift Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Page content
                const Expanded(
                  child: Center(
                    child: Text('Shift Management Content'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
