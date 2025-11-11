import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressChart extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;
  final Color progressColor;
  final double size;

  const ProgressChart({
    super.key,
    required this.progress,
    required this.title,
    required this.subtitle,
    this.progressColor = Colors.blue,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: size / 2,
          lineWidth: 8.0,
          percent: progress.clamp(0.0, 1.0),
          center: Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: progressColor,
            ),
          ),
          progressColor: progressColor,
          backgroundColor: progressColor.withOpacity(0.1),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class LinearProgressWithText extends StatelessWidget {
  final double progress;
  final String label;
  final Color progressColor;
  final String trailingText;

  const LinearProgressWithText({
    super.key,
    required this.progress,
    required this.label,
    this.progressColor = Colors.blue,
    this.trailingText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              trailingText.isNotEmpty ? trailingText : '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: progressColor.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}