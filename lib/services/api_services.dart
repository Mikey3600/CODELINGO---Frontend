import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart'; 

class ApiService {
  static const String baseUrl =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api";

  
  Future<List<Course>> fetchCourses() async {
    try {
      final uri = Uri.parse("$baseUrl/courses");

      final res = await http
          .get(uri, headers: {"Accept": "application/json"})
          .timeout(
            const Duration(seconds: 25),
            onTimeout: () => throw Exception("Request timed out."),
          );

      if (res.statusCode != 200) {
        debugPrint(" fetchCourses ERROR BODY: ${res.body}");
        throw Exception("Failed to fetch courses: ${res.statusCode}");
      }

      final data = jsonDecode(res.body);

      final list = (data["courses"] as List?) ?? [];

      return list.map((json) => Course.fromJson(json)).toList();
    } on SocketException {
      throw Exception("Network error — cannot reach backend.");
    } on HandshakeException {
      throw Exception("SSL handshake failed — restart ngrok.");
    } catch (e) {
      debugPrint(" fetchCourses ERROR: $e");
      rethrow;
    }
  }
}
