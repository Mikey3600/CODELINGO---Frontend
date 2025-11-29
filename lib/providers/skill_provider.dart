import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../services/skill_service.dart';

class SkillProvider extends ChangeNotifier {
  List<Skill> _skills = [];
  bool _loading = false;
  String? _error;

  List<Skill> get skills => _skills;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchSkills(String courseId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _skills = await SkillService.fetchSkills(courseId);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}

