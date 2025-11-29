import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';
import 'auth_service.dart';

class CourseService {
  static const String baseUrl =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api";

  /// Fetch all courses
  static Future<List<Course>> getCourses() async {
    try {
      final token = await AuthService.getToken();

      final headers = {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final uri = Uri.parse("$baseUrl/courses");

      final res = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 25));

      if (res.statusCode != 200) {
        debugPrint("❌ COURSE ERROR BODY: ${res.body}");
        throw Exception("Failed to load courses: ${res.statusCode}");
      }

      final body = jsonDecode(res.body);

      // backend returns: { success: true, courses: [] }
      final list = (body["courses"] as List?) ?? [];

      return list.map((json) => Course.fromJson(json)).toList();
    } on SocketException {
      throw Exception("Network error — cannot reach backend.");
    } on HandshakeException {
      throw Exception("SSL error — restart ngrok.");
    } catch (e) {
      debugPrint("❌ getCourses ERROR: $e");
      rethrow;
    }
  }
}
