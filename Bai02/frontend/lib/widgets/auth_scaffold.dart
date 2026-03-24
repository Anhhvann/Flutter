import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;

  const AuthScaffold({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient(
            Theme.of(context).brightness
          )
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -40,
              child: _Bubble(size: 180, color: AppTheme.accent.withOpacity(0.18))
            ),
            Positioned(
              bottom: -60,
              left: -40,
              child: _Bubble(size: 160, color: AppTheme.primary.withOpacity(0.12))
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6)
                            )
                      ),
                      const SizedBox(height: 24),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, childWidget) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 18 * (1 - value)),
                              child: childWidget
                            )
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 12)
                              )
                            ]
                          ),
                          child: child
                        )
                      )
                    ]
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final Color color;

  const _Bubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle)
    );
  }
}
