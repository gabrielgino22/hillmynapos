import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavRail extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const NavRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          // Logo section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo.png',
              height: 80,
            ),
          ),
          // User info section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Navigation buttons
          _buildNavButton(
            'Services',
            Icons.spa,
            0,
            selectedIndex == 0,
            onDestinationSelected,
          ),
          _buildNavButton(
            'Shift',
            Icons.access_time,
            1,
            selectedIndex == 1,
            onDestinationSelected,
          ),
          _buildNavButton(
            'Edit Services',
            Icons.edit,
            2,
            selectedIndex == 2,
            onDestinationSelected,
          ),
          _buildNavButton(
            'Receipts',
            Icons.receipt,
            3,
            selectedIndex == 3,
            onDestinationSelected,
          ),
          _buildNavButton(
            'Settings',
            Icons.settings,
            4,
            selectedIndex == 4,
            onDestinationSelected,
          ),
          _buildNavButton(
            'Back Office',
            Icons.business,
            5,
            selectedIndex == 5,
            onDestinationSelected,
          ),
          const Spacer(),
          // Logout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    String label,
    IconData icon,
    int index,
    bool isSelected,
    Function(int) onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ElevatedButton.icon(
        onPressed: () => onTap(index),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: isSelected ? 2 : 0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(16),
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }
}
