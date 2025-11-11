import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/quiz_provider.dart';
import 'package:cybersecurity_quiz_app/models/topic_model.dart';
import 'package:cybersecurity_quiz_app/screens/quiz_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    if (quizProvider.topics.isEmpty) {
      await quizProvider.loadTopics();
    }
  }

  void _startQuiz(Topic topic) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    
    final success = await quizProvider.loadTopicQuestions(topic.id);
    if (success && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QuizScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(quizProvider.error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBackendOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[800],
      builder: (context) {
        return BackendOptionsSheet(
          onRefresh: () async {
            Navigator.pop(context);
            final quizProvider = Provider.of<QuizProvider>(context, listen: false);
            await quizProvider.loadTopics();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Topics refreshed from backend'),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          onClearCache: () {
            Navigator.pop(context);
            final quizProvider = Provider.of<QuizProvider>(context, listen: false);
            quizProvider.resetQuiz();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared'),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _goToHomeDashboard() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Quiz Topics', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goToHomeDashboard,
          tooltip: 'Back to Dashboard',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showBackendOptions,
            tooltip: 'Backend Options',
          ),
        ],
      ),
      body: quizProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quizProvider.topics.isEmpty
              ? const EmptyState()
              : TopicsGrid(
                  topics: quizProvider.topics,
                  onTopicTap: _startQuiz,
                ),
    );
  }
}

class BackendOptionsSheet extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onClearCache;

  const BackendOptionsSheet({
    super.key,
    required this.onRefresh,
    required this.onClearCache,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Backend Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.white),
            title: const Text('Refresh from Backend', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Force reload topics from server', style: TextStyle(color: Colors.grey)),
            onTap: onRefresh,
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.clear_all, color: Colors.white),
            title: const Text('Clear Cache', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Clear locally stored data', style: TextStyle(color: Colors.grey)),
            onTap: onClearCache,
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.grey),
            title: const Text('Cancel', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class TopicsGrid extends StatelessWidget {
  final List<Topic> topics;
  final Function(Topic) onTopicTap;

  const TopicsGrid({
    super.key,
    required this.topics,
    required this.onTopicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return TopicCard(
            topic: topic,
            onTap: () => onTopicTap(topic),
          );
        },
      ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final Topic topic;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  topic.icon,
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                topic.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  topic.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[400]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(topic.difficultyText, style: const TextStyle(color: Colors.black)),
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  Text(
                    '${topic.questionsCount} Qs',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Topics Available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new cybersecurity topics',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}