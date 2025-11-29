import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'auth_service.dart';
import '../models/user_profile.dart';

class UserService {
  static const String base =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api";

  
  static Future<UserProfile> fetchMe() async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("Not logged in — no token found");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    
    final url = Uri.parse("$base/auth/me");

    try {
      final res = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      final data = _safeJson(res.body);

      
      if (res.statusCode == 200 && data["user"] != null) {
        return UserProfile.fromJson(data["user"]);
      }

      
      if (data["error"] != null) {
        throw Exception(data["error"]);
      }

      throw Exception("Failed to fetch user: ${res.statusCode}");
    } on SocketException {
      throw Exception("Network error — backend unreachable.");
    } on TimeoutException {
      throw Exception("Profile request timed out.");
    }
  }

  
  static Map<String, dynamic> _safeJson(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {};
    }
  }
}
