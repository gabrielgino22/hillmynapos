import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _firestore = FirebaseFirestore.instance;
  bool isDarkMode = false;
  bool showTutorial = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSection(
            'General Settings',
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Show Tutorial'),
                value: showTutorial,
                onChanged: (value) {
                  setState(() {
                    showTutorial = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  items: ['English', 'Filipino']
                      .map((lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLanguage = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            'Account Settings',
            [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Change Password'),
                onTap: () {
                  // Implement password change
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Privacy Settings'),
                onTap: () {
                  // Implement privacy settings
                },
              ),
            ],
          ),
          _buildSection(
            'System',
            [
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Check for Updates'),
                onTap: () {
                  // Implement update check
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}
