import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  List<Course> _courses = [];
  bool _loading = false;
  String? _error;

  List<Course> get courses => _courses;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchCourses() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _courses = await CourseService.getCourses();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
