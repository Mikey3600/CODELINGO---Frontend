import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://codelingo-backend.onrender.com";

  // Auth APIs
  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // Lessons APIs
  static Future<Map<String, dynamic>> getCLessons() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/lessons/c"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load lessons');
    }
  }

  // Questions APIs
  static Future<Map<String, dynamic>> getQuestions(String lessonId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/questions/$lessonId"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // Progress APIs
  static Future<Map<String, dynamic>> submitAnswer({
    required String userId,
    required String languageCode,
    required String lessonId,
    required String questionId,
    required int answer,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/progress/submit"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "languageCode": languageCode,
        "lessonId": lessonId,
        "questionId": questionId,
        "answer": answer,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to submit answer');
    }
  }

  static Future<Map<String, dynamic>> getUserProgress(String userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/progress/$userId/c"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load progress');
    }
  }
}
