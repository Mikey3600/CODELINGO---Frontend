import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';

class LessonProvider extends ChangeNotifier {
  List<Lesson> _lessons = [];
  Lesson? _lesson;
  bool _loading = false;
  String? _error;

  List<Lesson> get lessons => _lessons;
  Lesson? get lesson => _lesson;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchLessonsForSkill(String skillId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _lessons = await LessonService.getLessonsBySkill(skillId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchLessonById(String lessonId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _lesson = await LessonService.getLessonById(lessonId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
