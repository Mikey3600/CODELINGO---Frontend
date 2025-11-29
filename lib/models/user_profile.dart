class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarEmoji;
  final int totalXP;
  final int streakDays;
  final DateTime? lastActiveDate;
  final int dailyGoalXP;
  final String? currentCourse;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarEmoji,
    required this.totalXP,
    required this.streakDays,
    required this.lastActiveDate,
    required this.dailyGoalXP,
    required this.currentCourse,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json["_id"] ?? "",
      name: json["name"] ?? "Learner",
      email: json["email"] ?? "guest@example.com",
      avatarEmoji: json["avatarEmoji"] ?? "👨‍💻",
      totalXP: json["totalXP"] ?? 0,
      streakDays: json["streakDays"] ?? 0,
      lastActiveDate: json["lastActiveDate"] != null
          ? DateTime.parse(json["lastActiveDate"])
          : null,
      dailyGoalXP: json["dailyGoalXP"] ?? 50,
      currentCourse: json["currentCourse"],
    );
  }
}

