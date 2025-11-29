import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/skill_provider.dart';
import '../utils/colors.dart';
import '../utils/ui_helpers.dart';
import '../widgets/skill_node.dart';
import 'lesson_list_screen.dart';

class SkillTreeScreen extends StatefulWidget {
  final Course course;

  const SkillTreeScreen({Key? key, required this.course}) : super(key: key);

  @override
  State<SkillTreeScreen> createState() => _SkillTreeScreenState();
}

class _SkillTreeScreenState extends State<SkillTreeScreen> {
  // data is managed by SkillProvider

  @override
  void initState() {
    super.initState();
    // fetch via provider after first frame to avoid context across async gaps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SkillProvider>().fetchSkills(widget.course.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<SkillProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text('Failed to load skills: ${provider.error}'),
            );
          }

          final skills = provider.skills;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.only(
                        top:
                            MediaQuery.of(context).padding.top +
                            UIHelpers.spacingM,
                        left: UIHelpers.spacingM,
                        right: UIHelpers.spacingM,
                        bottom: UIHelpers.spacingL,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: UIHelpers.spacingS),
                          Text(
                            widget.course.iconEmoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: UIHelpers.spacingM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.course.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  "${skills.length} skills",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: UIHelpers.spacingXL,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final skill = skills[index];
                        final isLast = index == skills.length - 1;

                        return Column(
                          children: [
                            SkillNode(
                              skill: skill,
                              onTap: () {
                                if (skill.lessonsCount > 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          LessonListScreen(skill: skill),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Skill not unlocked yet."),
                                    ),
                                  );
                                }
                              },
                            ),
                            if (!isLast)
                              CustomPaint(
                                size: const Size(4, 60),
                                painter: _ConnectorLinePainter(
                                  color: skill.isUnlocked
                                      ? AppColors.primaryGreen.withOpacity(0.3)
                                      : AppColors.lockedGray,
                                ),
                              ),
                          ],
                        );
                      }, childCount: skills.length),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ConnectorLinePainter extends CustomPainter {
  final Color color;

  _ConnectorLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ConnectorLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
