import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/question.dart';
import '../utils/colors.dart';
import '../utils/ui_helpers.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentIndex = 0;
  String? _selectedAnswer;

  bool _showFeedback = false;
  bool _isCorrect = false;
  int _earnedXP = 0;

  Question get currentQuestion => widget.lesson.questions[_currentIndex];

  

  void _submitAnswer() {
    final q = currentQuestion;

    
    if (q.type == "mcq" && _selectedAnswer == null) {
      return;
    }

    bool correct = false;

    if (q.type == "mcq") {
      if (q.correctAnswerIndex != null &&
          q.correctAnswerIndex! >= 0 &&
          q.correctAnswerIndex! < q.options.length) {
        final correctOption = q.options[q.correctAnswerIndex!];
        correct = (_selectedAnswer == correctOption);
      }
    } else {
      
      correct = true;
    }

    setState(() {
      _isCorrect = correct;
      _showFeedback = true;
      if (correct) _earnedXP += q.xpReward;
    });
  }

  

  void _nextQuestion() {
    if (_currentIndex < widget.lesson.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
      });
    } else {
      // End of lesson
      Navigator.pop(context);
    }
  }

  

  Widget _buildMCQ(Question q) {
    return Column(
      children: q.options.map((opt) {
        final isSelected = _selectedAnswer == opt;
        return GestureDetector(
          onTap: () {
            if (_showFeedback) return;
            setState(() => _selectedAnswer = opt);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(UIHelpers.spacingM),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.shade200 : Colors.white,
              borderRadius: BorderRadius.circular(UIHelpers.radiusM),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryGreen
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Text(
              opt,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    final q = currentQuestion;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UIHelpers.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                "Question ${_currentIndex + 1}/${widget.lesson.questions.length}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: UIHelpers.spacingM),

              Text(
                q.questionText,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: UIHelpers.spacingXL),

              
              if (q.type == "mcq")
                _buildMCQ(q)
              else
                Container(
                  padding: const EdgeInsets.all(UIHelpers.spacingM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(UIHelpers.radiusM),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "This is a non-MCQ question.\n(User input UI coming soon!)",
                  ),
                ),

              const Spacer(),

              // FEEDBACK
              if (_showFeedback)
                Container(
                  padding: const EdgeInsets.all(UIHelpers.spacingM),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? Colors.green.shade200
                        : Colors.red.shade200,
                    borderRadius: BorderRadius.circular(UIHelpers.radiusM),
                  ),
                  child: Text(
                    _isCorrect ? "Correct! +${q.xpReward} XP" : "Incorrect",
                    style: TextStyle(
                      fontSize: 18,
                      color: _isCorrect ? AppColors.primaryGreen : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(height: UIHelpers.spacingM),

              
              ElevatedButton(
                onPressed: _showFeedback ? _nextQuestion : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.all(UIHelpers.spacingM),
                ),
                child: Text(
                  _showFeedback ? "Next" : "Check",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
