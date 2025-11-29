import 'question.dart';

class Lesson {
  final String id;
  final String languageId;
  final String title;
  final String description;
  final String difficulty;
  final List<Question> questions;

  Lesson({
    required this.id,
    required this.languageId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.questions,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json["_id"] ?? "",
      languageId: json["language"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      difficulty: json["difficulty"] ?? "beginner",
      questions: (json["questions"] as List? ?? [])
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}
