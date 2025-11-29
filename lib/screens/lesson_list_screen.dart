import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../models/lesson.dart';
import '../services/lesson_service.dart';
import '../utils/colors.dart';
import '../utils/ui_helpers.dart';
import 'lesson_screen.dart';

class LessonListScreen extends StatefulWidget {
  final Skill skill;

  const LessonListScreen({Key? key, required this.skill}) : super(key: key);

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  List<Lesson> _lessons = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    try {
      final list = await LessonService.getLessonsBySkill(widget.skill.id);
      setState(() {
        _lessons = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.skill.name,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: \\${_error}'))
          : ListView.separated(
              padding: const EdgeInsets.all(UIHelpers.spacingM),
              itemCount: _lessons.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: UIHelpers.spacingM),
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(UIHelpers.radiusM),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: lesson),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(UIHelpers.radiusM),
                    child: Padding(
                      padding: const EdgeInsets.all(UIHelpers.spacingM),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.accentBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                lesson.languageId,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: UIHelpers.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lesson.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: UIHelpers.spacingM),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.xpGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(
                                UIHelpers.radiusS,
                              ),
                            ),
                            child: Text(
                              lesson.difficulty,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
