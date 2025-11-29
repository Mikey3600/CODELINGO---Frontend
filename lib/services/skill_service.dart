import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/skill.dart';
import 'auth_service.dart';

class SkillService {
  static const String baseUrl =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api";

  /// Fetch all skills inside a course
  static Future<List<Skill>> fetchSkills(String courseId) async {
    try {
      final token = await AuthService.getToken();

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse("$baseUrl/skills/course/$courseId");

      final res = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 25));

      if (res.statusCode != 200) {
        debugPrint("SKILLS ERROR: ${res.body}");
        throw Exception("Failed to load skills: ${res.statusCode}");
      }

      final data = jsonDecode(res.body);

      // 🔥 FIX HERE — correct JSON structure
      final List list = data["data"]?["skills"] ?? [];

      return list.map((e) => Skill.fromJson(e)).toList();
    } on SocketException {
      throw Exception("Network error — check ngrok tunnel.");
    } catch (e) {
      debugPrint("fetchSkills ERROR: $e");
      rethrow;
    }
  }
}
