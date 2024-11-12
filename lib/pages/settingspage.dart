import 'package:myapp/sub-subpage/aboutus.dart';
import 'package:myapp/sub-subpage/feedback.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('FeedBack'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()),
              );

              // Navigate to notifications settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_rounded),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsPage()),
              );
              // Navigate to notifications settings page
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.update),
            title: const Text('Check For Update'),
            onTap: () {
              // Navigate to help center page
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Toggle dark mode
              },
            ),
          ),
        ],
      ),
    );
  }
}
