import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await ApiClient().clearTokens();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile")
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 10)
                  )
                ]
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.secondary.withOpacity(0.2),
                    child: const Icon(Icons.person, color: AppTheme.primary)
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reader Pro",
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "reader@example.com",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6)
                          )
                        )
                      ]
                    )
                  ),
                  const Icon(Icons.verified, color: AppTheme.accent)
                ]
              )
            ),
            const SizedBox(height: 18),
            _InfoTile(
              title: "My orders",
              subtitle: "View recent purchases",
              icon: Icons.shopping_bag_outlined
            ),
            _InfoTile(
              title: "Saved books",
              subtitle: "Wishlist and favorites",
              icon: Icons.bookmark_border
            ),
            _InfoTile(
              title: "Payment",
              subtitle: "Manage cards and billing",
              icon: Icons.credit_card
            ),
            _InfoTile(
              title: "Support",
              subtitle: "Need help?",
              icon: Icons.support_agent
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: "Logout",
              onPressed: () => _logout(context),
              leadingIcon: Icons.logout
            )
          ]
        )
      )
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.subtitle,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8)
          )
        ]
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Icon(icon, color: AppTheme.secondary)
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600)
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.6)
                  )
                )
              ]
            )
          ),
          const Icon(Icons.chevron_right)
        ]
      )
    );
  }
}
