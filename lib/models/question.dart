class Question {
  final String id;
  final String type; 
  final String questionText;
  final List<String> options;

  final int? correctAnswerIndex;
  final String? starterCode;
  final String? expectedOutput;
  final String? explanation;

  final int xpReward;

  Question({
    required this.id,
    required this.type,
    required this.questionText,
    required this.options,
    this.correctAnswerIndex,
    this.starterCode,
    this.expectedOutput,
    this.explanation,
    required this.xpReward,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["_id"] ?? "",
      type: json["type"] ?? "mcq",
      questionText: json["questionText"] ?? "",
      options: (json["options"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      correctAnswerIndex: json["correctAnswerIndex"],
      starterCode: json["starterCode"],
      expectedOutput: json["expectedOutput"],
      explanation: json["explanation"] ?? "",
      xpReward: json["xpReward"] ?? 10,
    );
  }
}
