import 'package:flutter/material.dart';
import '../services/ai_tutor_service.dart';

class AITutorProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  List<Map<String, String>> _messages = [];

  bool get loading => _loading;
  String? get error => _error;
  List<Map<String, String>> get messages => _messages;

  Future<void> askQuestion(String question, {String language = 'python', String level = 'beginner'}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final reply = await AITutorService.ask(question: question, language: language, level: level);
      _messages.add({'from': 'user', 'text': question});
      _messages.add({'from': 'ai', 'text': reply});
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> revealSolution(String question, {String language = 'python'}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final reply = await AITutorService.revealSolution(question: question, language: language);
      _messages.add({'from': 'ai', 'text': reply});
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
