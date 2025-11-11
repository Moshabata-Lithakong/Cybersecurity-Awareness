import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cybersecurity_quiz_app/models/question_model.dart';
import 'package:cybersecurity_quiz_app/screens/topics_screen.dart';

class ResultsScreen extends StatelessWidget {
  final dynamic quizResult;

  const ResultsScreen({super.key, required this.quizResult});

  @override
  Widget build(BuildContext context) {
    final result = QuizResult.fromJson(quizResult['data']['quizResult']);
    final performance = quizResult['data']['performance'];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Quiz Results', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: Container(), // Remove back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Card
            Card(
              color: Colors.grey[800],
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 60,
                      lineWidth: 8,
                      percent: result.percentage / 100,
                      center: Text(
                        '${result.percentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      progressColor: result.performanceColor,
                      backgroundColor: Colors.grey[600]!,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      result.performanceText,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: result.performanceColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You scored ${result.score} out of ${result.totalQuestions}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ResultStat(
                          label: 'Correct',
                          value: result.score.toString(),
                          color: Colors.white,
                        ),
                        _ResultStat(
                          label: 'Wrong',
                          value: (result.totalQuestions - result.score).toString(),
                          color: Colors.white,
                        ),
                        _ResultStat(
                          label: 'Time',
                          value: '${(result.timeSpent / 60).ceil()}m',
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const TopicsScreen()),
                        (route) => false,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text('Back to Topics', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Retry same topic
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const TopicsScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Try Again'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Answers Review
            Text(
              'Review Answers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ...result.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              return _AnswerReviewCard(
                questionNumber: index + 1,
                answer: answer,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
        ),
      ],
    );
  }
}

class _AnswerReviewCard extends StatelessWidget {
  final int questionNumber;
  final Answer answer;

  const _AnswerReviewCard({
    required this.questionNumber,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: answer.isCorrect ? Colors.grey[700] : Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: answer.isCorrect ? Colors.white : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                answer.isCorrect ? Icons.check : Icons.close,
                size: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Q$questionNumber',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              answer.isCorrect ? 'Correct' : 'Incorrect',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: answer.isCorrect ? Colors.white : Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}