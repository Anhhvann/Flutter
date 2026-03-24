import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final String title;
  final String subtitle;

  const AppLogo({
    super.key,
    required this.title,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16)
          ),
          child: const Icon(Icons.auto_stories, color: Colors.white, size: 28)
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
            ),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                    ?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6)
                    )
            )
          ]
        )
      ]
    );
  }
}
