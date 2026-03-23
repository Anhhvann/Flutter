import 'package:flutter/material.dart';

import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manager App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TeamIntroPage(),
    );
  }
}

class TeamIntroPage extends StatefulWidget {
  const TeamIntroPage({super.key});

  @override
  State<TeamIntroPage> createState() => _TeamIntroPageState();
}

class _TeamIntroPageState extends State<TeamIntroPage> {
  static const int _initialSeconds = 10;
  late int _secondsLeft;
  Timer? _countdownTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _secondsLeft = _initialSeconds;
    _startCountdown();
    _scheduleNavigation();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _scheduleNavigation() {
    _navigationTimer = Timer(const Duration(seconds: _initialSeconds), () {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const ManagerLoginPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MANAGER APP',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Giới thiệu thành viên nhóm',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 28),
                const MemberCard(name: 'Thanh Trà'),
                const SizedBox(height: 12),
                const MemberCard(name: 'Diễm Ngọc'),
                const SizedBox(height: 12),
                const MemberCard(name: 'Vân Ánh'),
                const SizedBox(height: 28),
                Text(
                  'Tự chuyển sang trang Login sau $_secondsLeft giây',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF00838F),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class ManagerLoginPage extends StatelessWidget {
  const ManagerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - Manager'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Tên đăng nhập manager',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('Đăng nhập'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
