import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _recommendations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings")
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient(
            Theme.of(context).brightness
          )
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SwitchListTile(
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
              title: const Text("Notifications"),
              subtitle: const Text("Get updates and offers")
            ),
            SwitchListTile(
              value: _recommendations,
              onChanged: (value) => setState(() => _recommendations = value),
              title: const Text("Personalized picks"),
              subtitle: const Text("Show recommended books")
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text("Theme"),
              subtitle: const Text("Use system appearance")
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About"),
              subtitle: const Text("Version 1.0.0")
            )
          ]
        )
      )
    );
  }
}
