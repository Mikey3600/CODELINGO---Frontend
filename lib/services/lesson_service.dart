import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/lesson.dart';
import 'auth_service.dart';

class LessonService {
  static const String base =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api";

  /// -------------------------------
  /// GET ALL LESSONS IN A SKILL
  /// -------------------------------
  static Future<List<Lesson>> getLessonsBySkill(String skillId) async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("Not logged in — missing token");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final url = Uri.parse("$base/lessons/skill/$skillId");

    try {
      final res = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      final data = _safeJson(res.body);

      if (res.statusCode == 200 && data["lessons"] != null) {
        final raw = (data["lessons"] as List?) ?? [];
        return raw.map((e) => Lesson.fromJson(e)).toList();
      }

      throw Exception(data["error"] ?? "Failed to load lessons");
    } on SocketException {
      throw Exception("Network error — check ngrok");
    } on TimeoutException {
      throw Exception("Timeout while loading lessons");
    }
  }

  /// -------------------------------
  /// GET SINGLE LESSON BY ID
  /// -------------------------------
  static Future<Lesson> getLessonById(String lessonId) async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception("Not logged in — missing token");
    }

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final url = Uri.parse("$base/lessons/$lessonId");

    try {
      final res = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 20));

      final data = _safeJson(res.body);

      if (res.statusCode == 200 && data["lesson"] != null) {
        return Lesson.fromJson(data["lesson"]);
      }

      throw Exception(data["error"] ?? "Failed to load lesson");
    } on SocketException {
      throw Exception("Network error — backend unreachable");
    } on TimeoutException {
      throw Exception("Timeout while fetching lesson");
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
