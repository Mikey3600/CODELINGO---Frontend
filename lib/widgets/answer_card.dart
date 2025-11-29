// filename: lib/widgets/answer_card.dart

import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/ui_helpers.dart';

/// Interactive answer card for multiple choice questions
class AnswerCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool? isCorrect; // null = not answered yet
  final VoidCallback onTap;
  
  const AnswerCard({
    Key? key,
    required this.text,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color backgroundColor;
    Color textColor = AppColors.textPrimary;
    
    if (isCorrect != null) {
      // Answered state
      if (isCorrect!) {
        borderColor = AppColors.correctGreen;
        backgroundColor = AppColors.correctGreen.withOpacity(0.1);
        textColor = AppColors.correctGreen;
      } else if (isSelected) {
        borderColor = AppColors.incorrectRed;
        backgroundColor = AppColors.incorrectRed.withOpacity(0.1);
        textColor = AppColors.incorrectRed;
      } else {
        borderColor = AppColors.lockedGray;
        backgroundColor = Colors.white;
      }
    } else {
      // Not answered yet
      if (isSelected) {
        borderColor = AppColors.accentBlue;
        backgroundColor = AppColors.accentBlue.withOpacity(0.05);
      } else {
        borderColor = AppColors.lockedGray;
        backgroundColor = Colors.white;
      }
    }
    
    return GestureDetector(
      onTap: isCorrect == null ? onTap : null, // Disable after answering
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(UIHelpers.spacingM),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(UIHelpers.radiusM),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected && isCorrect == null
              ? UIHelpers.cardShadow
              : [],
        ),
        child: Row(
          children: [
            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 2,
                ),
                color: isSelected ? borderColor : Colors.transparent,
              ),
              child: isSelected && isCorrect != null
                  ? Icon(
                      isCorrect! ? Icons.check : Icons.close,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            
            const SizedBox(width: UIHelpers.spacingM),
            
            // Answer text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
