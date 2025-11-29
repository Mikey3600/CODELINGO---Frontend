import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TutorService {
  
  static const String base =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api/tutor";

  
  static Future<String> askTutor({
    required String question,
    String language = "python",
    String level = "beginner",
    String? code,
  }) async {
    final token = await AuthService.getToken();

    final headers = <String, String>{
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final url = Uri.parse("$base/ask");

    final body = jsonEncode({
      "question": question,
      "language": language,
      "level": level,
      if (code != null) "code": code,
    });

    try {
      final res = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 20));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body);
        return json["response"] ?? "No response from AI tutor.";
      }

      throw Exception("Tutor error: ${res.statusCode}");
    } on SocketException {
      throw Exception("Network error — AI tutor unreachable");
    } on TimeoutException {
      throw Exception("Tutor request timed out");
    }
  }

  /// Reveal full solution after “I can’t do it”
  static Future<String> revealSolution({
    required String question,
    String language = "python",
  }) async {
    final token = await AuthService.getToken();

    final headers = <String, String>{
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    final url = Uri.parse("$base/solution");

    final body = jsonEncode({"question": question, "language": language});

    try {
      final res = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 20));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = jsonDecode(res.body);
        return json["solution"] ?? "No solution returned.";
      }

      throw Exception("Tutor solution error: ${res.statusCode}");
    } on SocketException {
      throw Exception("Network error — AI tutor unreachable");
    } on TimeoutException {
      throw Exception("Solution request timed out");
    }
  }
}
