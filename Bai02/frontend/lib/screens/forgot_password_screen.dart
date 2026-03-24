import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _api = ApiClient();

  bool _loading = false;
  String? _error;

  bool _isValidEmail(String value) {
    return RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(value);
  }

  Future<void> _requestOtp() async {
    final email = _emailController.text.trim();

    setState(() => _error = null);

    if (!_isValidEmail(email)) {
      setState(() => _error = "Please enter a valid email.");
      return;
    }

    setState(() => _loading = true);
    final result = await _api.forgotPassword(email: email);
    setState(() => _loading = false);

    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      "/reset",
      arguments: {"email": email}
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Reset access",
      subtitle: "We will send an OTP to your email.",
      child: LoadingOverlay(
        isLoading: _loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLogo(title: "Forgot password", subtitle: "We will help you reset"),
            const SizedBox(height: 16),
            AppTextField(
              controller: _emailController,
              label: "Email",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.alternate_email,
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
              label: "Send OTP",
              onPressed: _requestOtp,
              leadingIcon: Icons.send
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
