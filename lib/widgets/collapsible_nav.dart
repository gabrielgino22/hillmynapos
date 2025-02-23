import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CollapsibleNav extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  const CollapsibleNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<CollapsibleNav> createState() => _CollapsibleNavState();
}

class _CollapsibleNavState extends State<CollapsibleNav> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isExpanded ? 250 : 70,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            IconButton(
              icon: Icon(isExpanded ? Icons.menu_open : Icons.menu),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('assets/logo.png', height: 60),
                    const SizedBox(height: 8),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? 'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),
            ],
            _buildNavItem('Services', Icons.spa, 0),
            _buildNavItem('Shift', Icons.access_time, 1),
            _buildNavItem('Edit Services', Icons.edit, 2),
            _buildNavItem('Receipts', Icons.receipt, 3),
            _buildNavItem('Settings', Icons.settings, 4),
            _buildNavItem('Back Office', Icons.business, 5),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isExpanded
                  ? ElevatedButton.icon(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () => FirebaseAuth.instance.signOut(),
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, int index) {
    final bool isSelected = widget.selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: () => widget.onDestinationSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.green.withOpacity(
                    0.2) // Fixed: Use withOpacity instead of withValues
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.green : Colors.grey[700],
              ),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.green : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
