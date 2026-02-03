import 'dart:math';
import 'package:flutter/material.dart';

class MatchScoreGauge extends StatelessWidget {
  final double score; // 0.0 to 1.0

  const MatchScoreGauge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: score),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // The Gauge Graphic
            CustomPaint(
              size: const Size(140, 140),
              painter: _GaugePainter(
                score: value,
                // Soften the track color for better contrast on the gradient card
                trackColor: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            // The Percentage Text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${(value * 100).toInt()}",
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                Text(
                  "MATCH",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.6),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color trackColor;

  _GaugePainter({required this.score, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 14.0;

    // 1. Draw the Background Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 1.1, // Start angle
      pi * 1.8, // Sweep angle
      false,
      trackPaint,
    );

    // 2. Draw the Progress Arc (The Score)
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.white, Colors.white70],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // We limit the sweep based on the score (multiplied by the total track length)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 1.1,
      (pi * 1.8) * score,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.score != score;
}
