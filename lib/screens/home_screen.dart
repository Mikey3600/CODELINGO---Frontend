import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../models/user_profile.dart';        
import '../providers/course_provider.dart';
import '../providers/user_provider.dart';

import '../utils/colors.dart';
import '../utils/ui_helpers.dart';
import '../widgets/top_bar.dart';

import 'skill_tree_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().fetchCourses();
      context.read<UserProvider>().fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            
            Consumer<UserProvider>(
              builder: (context, userP, _) {
                final UserProfile profile = userP.user ??
                    UserProfile(
                      id: "0",
                      name: "Learner",
                      email: "guest@example.com",
                      avatarEmoji: "👨‍💻",
                      totalXP: 0,
                      streakDays: 0,
                      lastActiveDate: null,
                      dailyGoalXP: 50,
                      currentCourse: null,
                    );

                return TopBar(profile: profile);
              },
            ),

          
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, cp, _) {
                  if (cp.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (cp.error != null) {
                    return Center(
                      child: Text(
                        "Failed to load courses:\n${cp.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final List<Course> courses = cp.courses;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(UIHelpers.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: UIHelpers.spacingS),

                        const Text(
                          "Courses",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: UIHelpers.spacingM),

                        Column(
                          children: courses
                              .map((c) => _buildCourseCard(context, c))
                              .toList(),
                        ),

                        const SizedBox(height: UIHelpers.spacingXL),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildCourseCard(BuildContext context, Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: UIHelpers.spacingM),
      padding: const EdgeInsets.all(UIHelpers.spacingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(UIHelpers.radiusL),
        boxShadow: UIHelpers.cardShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(UIHelpers.radiusL),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SkillTreeScreen(course: course),
            ),
          );
        },
        child: Row(
          children: [
            // EMOJI CIRCLE
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  course.iconEmoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),

            const SizedBox(width: UIHelpers.spacingM),

            // COURSE INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${course.totalSkills} skills • ${course.languageCode.toUpperCase()}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}




