// filename: lib/widgets/progress_ring.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Custom painter for circular progress ring around skill nodes
class ProgressRingPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color ringColor;
  final Color backgroundColor;
  final double strokeWidth;
  
  ProgressRingPainter({
    required this.progress,
    required this.ringColor,
    required this.backgroundColor,
    this.strokeWidth = 6.0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Draw progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      
      // Start from top (-90 degrees = -pi/2 radians)
      const startAngle = -math.pi / 2;
      final sweepAngle = 2 * math.pi * progress;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

/// Widget wrapper for progress ring
class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final Color? ringColor;
  final Color? backgroundColor;
  final Widget? child;
  
  const ProgressRing({
    Key? key,
    required this.progress,
    this.size = 80.0,
    this.ringColor,
    this.backgroundColor,
    this.child,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: ProgressRingPainter(
              progress: progress,
              ringColor: ringColor ?? const Color(0xFF58CC02),
              backgroundColor: backgroundColor ?? const Color(0xFFE5E5E5),
              strokeWidth: size * 0.075, // Proportional stroke width
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
