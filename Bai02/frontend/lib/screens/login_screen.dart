import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _api = ApiClient();

  bool _loading = false;
  String? _error;

  bool _isValidEmail(String value) {
    return RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _error = null);

    if (!_isValidEmail(email)) {
      setState(() => _error = "Please enter a valid email.");
      return;
    }

    if (password.length < 6) {
      setState(() => _error = "Password must be at least 6 characters.");
      return;
    }

    setState(() => _loading = true);
    final result = await _api.login(email: email, password: password);
    setState(() => _loading = false);

    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login successful"))
    );
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Welcome back",
      subtitle: "Sign in to continue your journey.",
      child: LoadingOverlay(
        isLoading: _loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLogo(title: "Bookly", subtitle: "Read more, learn more"),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emailController,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: "Password",
              obscureText: true,
              prefixIcon: Icons.lock_outline,
              textInputAction: TextInputAction.done
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent)
              ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: "Login",
              onPressed: _login,
              leadingIcon: Icons.login
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/forgot"),
              child: const Text("Forgot password?")
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/register"),
              child: const Text("Create a new account")
            )
          ]
        )
      )
    );
  }
}
