import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _api = ApiClient();

  bool _loading = false;
  String? _error;

  Future<void> _resetPassword() async {
    final otp = _otpController.text.trim();
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() => _error = null);

    if (otp.isEmpty) {
      setState(() => _error = "Please enter the OTP.");
      return;
    }

    if (newPassword.length < 6) {
      setState(() => _error = "Password must be at least 6 characters.");
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => _error = "Passwords do not match.");
      return;
    }

    setState(() => _loading = true);
    final result = await _api.resetPassword(
      email: widget.email,
      otp: otp,
      newPassword: newPassword
    );
    setState(() => _loading = false);

    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password updated"))
    );
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Set a new password",
      subtitle: "Enter the OTP and a new password.",
      child: LoadingOverlay(
        isLoading: _loading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppLogo(title: "Reset password", subtitle: "Secure your account"),
            const SizedBox(height: 16),
            Text(
              "Email: ${widget.email}",
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.6)
              )
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _otpController,
              label: "OTP",
              keyboardType: TextInputType.number,
              prefixIcon: Icons.verified_outlined
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _passwordController,
              label: "New password",
              obscureText: true,
              prefixIcon: Icons.lock_outline
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _confirmPasswordController,
              label: "Confirm password",
              obscureText: true,
              prefixIcon: Icons.lock_reset,
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
              label: "Update password",
              onPressed: _resetPassword,
              leadingIcon: Icons.check_circle_outline
            )
          ]
        )
      )
    );
  }
}
