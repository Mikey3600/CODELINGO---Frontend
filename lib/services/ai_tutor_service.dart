import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AITutorService {
  static const String base =
      "https://katherin-unstation-instantaneously.ngrok-free.dev/api/tutor";

  static Future<String> ask({
    required String question,
    required String language,
    required String level,
    String? code,
  }) async {
    final token = await AuthService.getToken();

    final url = Uri.parse("$base/ask");

    try {
      final res = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authorization": "Bearer $token",
            },
            body: jsonEncode({
              "question": question,
              "language": language,
              "level": level,
              if (code != null) "code": code,
            }),
          )
          .timeout(const Duration(seconds: 25));

      final json = _safeJson(res.body);

      if (res.statusCode == 200 && json["response"] != null) {
        return json["response"];
      }

      throw Exception(json["error"] ?? "AI Tutor failed");
    } on SocketException {
      throw Exception("No internet / ngrok offline");
    }
  }

  
  static Future<String> revealSolution({
    required String question,
    required String language,
  }) async {
    final token = await AuthService.getToken();
    final url = Uri.parse("$base/solution");

    try {
      final res = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authorization": "Bearer $token",
            },
            body: jsonEncode({"question": question, "language": language}),
          )
          .timeout(const Duration(seconds: 25));

      final json = _safeJson(res.body);

      if (res.statusCode == 200 && json["solution"] != null) {
        return json["solution"];
      }

      throw Exception(json["error"] ?? "Failed to fetch solution");
    } on SocketException {
      throw Exception("Network error");
    }
  }

  
  static Future<String> uploadAndAsk({
    required File file,
    required String question,
    required String language,
    required String level,
  }) async {
    final token = await AuthService.getToken();
    final url = Uri.parse("$base/ask/upload");

    try {
      final req = http.MultipartRequest("POST", url);

      if (token != null) req.headers["Authorization"] = "Bearer $token";

      req.fields["question"] = question;
      req.fields["language"] = language;
      req.fields["level"] = level;

      req.files.add(await http.MultipartFile.fromPath("file", file.path));

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      final json = _safeJson(res.body);

      if (res.statusCode == 200 && json["response"] != null) {
        return json["response"];
      }

      throw Exception(json["error"] ?? "Upload failed");
    } on SocketException {
      throw Exception("No internet / ngrok offline");
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
