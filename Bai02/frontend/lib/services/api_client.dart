import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiResult {
  final bool success;
  final String message;
  final Map<String, dynamic> data;

  ApiResult({
    required this.success,
    required this.message,
    required this.data
  });
}

class ApiClient {
  static const String baseUrl = "http://localhost:3000";

  Future<ApiResult> register({
    required String username,
    required String email,
    required String password
  }) {
    return _post(
      "/api/auth/register",
      {"username": username, "email": email, "password": password}
    );
  }

  Future<ApiResult> verifyOtp({required String email, required String otp}) {
    return _post("/api/auth/verify-otp", {"email": email, "otp": otp});
  }

  Future<ApiResult> login({required String email, required String password}) async {
    final result = await _post(
      "/api/auth/login",
      {"email": email, "password": password}
    );

    if (result.success && result.data["accessToken"] != null) {
      await saveTokens(
        result.data["accessToken"],
        result.data["refreshToken"]
      );
    }

    return result;
  }

  Future<ApiResult> forgotPassword({required String email}) {
    return _post("/api/auth/forgot-password", {"email": email});
  }

  Future<ApiResult> resetPassword({
    required String email,
    required String otp,
    required String newPassword
  }) {
    return _post(
      "/api/auth/reset-password",
      {"email": email, "otp": otp, "newPassword": newPassword}
    );
  }

  Future<ApiResult> _post(String path, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$path"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
      );

      final Map<String, dynamic> jsonBody = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>
          : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResult(
          success: true,
          message: jsonBody["message"]?.toString() ?? "Success",
          data: jsonBody
        );
      }

      return ApiResult(
        success: false,
        message: jsonBody["message"]?.toString() ?? "Request failed",
        data: jsonBody
      );
    } catch (error) {
      return ApiResult(
        success: false,
        message: "Network error",
        data: {}
      );
    }
  }

  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", accessToken);
    if (refreshToken != null) {
      await prefs.setString("refreshToken", refreshToken);
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    await prefs.remove("refreshToken");
  }
}
