import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  final _api = ApiClient();

  bool _loading = false;
  bool _otpSent = false;
  String? _error;

  bool _isValidEmail(String value) {
    return RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value);
  }

  Future<void> _sendOtp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _error = null);

    if (username.isEmpty) {
      setState(() => _error = "Please enter your name.");
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() => _error = "Please enter a valid email.");
      return;
    }

    if (password.length < 6) {
      setState(() => _error = "Password must be at least 6 characters.");
      return;
    }

    setState(() => _loading = true);
    final result = await _api.register(
      username: username,
      email: email,
      password: password
    );
    setState(() => _loading = false);

    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }

    setState(() => _otpSent = true);
  }

  Future<void> _verifyOtp() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    setState(() => _error = null);

    if (otp.length < 4) {
      setState(() => _error = "Please enter the OTP.");
      return;
    }

    setState(() => _loading = true);
    final result = await _api.verifyOtp(email: email, otp: otp);
    setState(() => _loading = false);

    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created"))
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Create account",
      subtitle: "Register with OTP verification.",
      child: LoadingOverlay(
        isLoading: _loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLogo(title: "Create account", subtitle: "Start your library"),
            const SizedBox(height: 16),
            AppTextField(
              controller: _usernameController,
              label: "Full name",
              prefixIcon: Icons.person_outline
            ),
            const SizedBox(height: 12),
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
              prefixIcon: Icons.lock_outline
            ),
            const SizedBox(height: 12),
            if (_otpSent) ...[
              AppTextField(
                controller: _otpController,
                label: "OTP",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.verified_outlined,
                textInputAction: TextInputAction.done
              ),
              const SizedBox(height: 6),
              const Text(
                "OTP expires in 5 minutes.",
                style: TextStyle(color: Colors.black54, fontSize: 12)
              ),
              const SizedBox(height: 12)
            ],
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent)
              ),
            const SizedBox(height: 12),
            if (!_otpSent)
              PrimaryButton(
                label: "Send OTP",
                onPressed: _sendOtp,
                leadingIcon: Icons.mark_email_read_outlined
              )
            else
              PrimaryButton(
                label: "Verify OTP",
                onPressed: _verifyOtp,
                leadingIcon: Icons.verified
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to login")
            )
          ]
        )
      )
    );
  }
}
