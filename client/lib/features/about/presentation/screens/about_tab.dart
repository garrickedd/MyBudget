import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Icon(Icons.info, size: 80, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            'About MyBudget',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.app_registration, color: Colors.blue),
            title: Text(
              'Application: MyBudget',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.label, color: Colors.blue),
            title: Text('Version: 1.0.0', style: TextStyle(fontSize: 18)),
          ),
          const ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text(
              'Developer: Trần Anh Dũng',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text(
              'Support Email: dungta.personal@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.web, color: Colors.blue),
            title: const Text('Visit Website', style: TextStyle(fontSize: 18)),
            onTap:
                () => _launchURL(
                  'https://github.com/garrickedd',
                ), // Placeholder URL
          ),
          ListTile(
            leading: const Icon(Icons.code, color: Colors.blue),
            title: const Text(
              'View Source Code',
              style: TextStyle(fontSize: 18),
            ),
            onTap:
                () => _launchURL(
                  'https://github.com/garrickedd/MyBudget',
                ), // Placeholder URL
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2025 MyBudget. All rights reserved.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
