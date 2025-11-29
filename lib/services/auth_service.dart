import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _base =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api";
  static const String _tokenKey = "auth_token";

  static Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  /// REGISTER
  static Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$_base/auth/register");

    final res = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        "name": name.trim(),
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    final body = jsonDecode(res.body);

    if (res.statusCode == 200 || res.statusCode == 201) {
      await _saveToken(body["token"]);
      return body["token"];
    } else {
      throw Exception(body["message"] ?? "Registration failed");
    }
  }

  /// LOGIN
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$_base/auth/login");

    final res = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        "email": email.trim(),
        "password": password.trim(),
      }),
    );

    final body = jsonDecode(res.body);

    if (res.statusCode == 200 && body["success"] == true) {
      await _saveToken(body["token"]);
      return body["token"];
    } else {
      throw Exception(body["message"] ?? "Invalid email or password");
    }
  }

  
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
