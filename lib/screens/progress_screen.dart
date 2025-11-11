import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/user_provider.dart';
import 'package:cybersecurity_quiz_app/models/user_model.dart';
import 'package:cybersecurity_quiz_app/models/question_model.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to load data after build
    Future.microtask(() => _loadProgress());
  }

  Future<void> _loadProgress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserProgress();
    await userProvider.loadQuizHistory();
    if (mounted) {
      setState(() {
        _initialLoad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: _initialLoad || userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Stats
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            'Overall Performance',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.4,
                            ),
                            children: [
                              _ProgressStat(
                                title: 'Quizzes Completed',
                                value: userProvider.progressStats?.totalQuizzesTaken.toString() ?? '0',
                                icon: Icons.quiz_rounded,
                                color: Colors.blue,
                              ),
                              _ProgressStat(
                                title: 'Average Score',
                                value: '${userProvider.progressStats?.averageScore.toStringAsFixed(1) ?? '0'}%',
                                icon: Icons.analytics_rounded,
                                color: Colors.green,
                              ),
                              _ProgressStat(
                                title: 'Total Questions',
                                value: userProvider.progressStats?.totalQuestionsAnswered.toString() ?? '0',
                                icon: Icons.question_answer_rounded,
                                color: Colors.orange,
                              ),
                              _ProgressStat(
                                title: 'Accuracy',
                                value: '${userProvider.progressStats?.accuracy.toStringAsFixed(1) ?? '0'}%',
                                icon: Icons.track_changes_rounded,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Completed Topics
                  Text(
                    'Completed Topics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (userProvider.progressStats?.completedTopics.isEmpty ?? true)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.topic_outlined, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No topics completed yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: userProvider.progressStats!.completedTopics
                          .map((topic) => _CompletedTopicCard(topic: topic))
                          .toList(),
                    ),
                  const SizedBox(height: 24),
                  // Quiz History
                  Text(
                    'Recent Quizzes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (userProvider.quizHistory.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.history_rounded, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No quiz history yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: userProvider.quizHistory
                          .take(5)
                          .map((quiz) => _QuizHistoryCard(quiz: quiz))
                          .toList(),
                    ),
                ],
              ),
            ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ProgressStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedTopicCard extends StatelessWidget {
  final CompletedTopic topic;

  const _CompletedTopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Text(
          topic.topicIcon ?? '📚',
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(topic.topicName),
        subtitle: Text('Completed on ${_formatDate(topic.completedAt)}'),
        trailing: Chip(
          label: Text('${topic.bestScore.toInt()}%'),
          backgroundColor: _getScoreColor(topic.bestScore).withOpacity(0.1),
          labelStyle: TextStyle(
            color: _getScoreColor(topic.bestScore),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.lightGreen;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _QuizHistoryCard extends StatelessWidget {
  final QuizResult quiz;

  const _QuizHistoryCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: quiz.performanceColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${quiz.percentage.toInt()}%',
              style: TextStyle(
                color: quiz.performanceColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
        title: Text(quiz.topicName),
        subtitle: Text('${quiz.score}/${quiz.totalQuestions} • ${_formatTime(quiz.completedAt)}'),
        trailing: Icon(
          quiz.percentage >= 70 ? Icons.check_circle : Icons.info_rounded,
          color: quiz.percentage >= 70 ? Colors.green : Colors.orange,
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}