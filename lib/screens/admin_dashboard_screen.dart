import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/auth_provider.dart';
import 'package:cybersecurity_quiz_app/providers/quiz_provider.dart';
import 'package:cybersecurity_quiz_app/providers/user_provider.dart';
import 'package:cybersecurity_quiz_app/providers/notification_provider.dart';
import 'package:cybersecurity_quiz_app/models/topic_model.dart';
import 'package:cybersecurity_quiz_app/models/question_model.dart';
import 'package:cybersecurity_quiz_app/models/user_model.dart';
import 'package:cybersecurity_quiz_app/models/notification_model.dart';
import 'package:cybersecurity_quiz_app/screens/landing_screen.dart';
import 'admin_dialogs.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdminOverview(),
    const UserManagementScreen(),
    const ContentManagementScreen(),
    const AnalyticsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      quizProvider.loadTopics();
      userProvider.loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (!authProvider.isAdmin) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Access Denied', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => _goBackToLanding(context),
          ),
        ),
        body: const Center(
          child: Text(
            'You do not have permission to access the admin dashboard.',
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                image: const DecorationImage(
                  image: AssetImage('assets/images/university_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'CyberGuard LK - Admin',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => _goBackToLanding(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded),
            label: 'Content',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  void _goBackToLanding(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingScreen()),
      (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      await authProvider.logout();
      
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LandingScreen()),
          (route) => false,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged out successfully', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}', style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class AdminOverview extends StatelessWidget {
  const AdminOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admin Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 24),
          
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            children: [
              _AdminStatCard(
                title: 'Total Users',
                value: userProvider.totalUsers.toString(),
                subtitle: 'Registered users',
                icon: Icons.people_rounded,
                color: Colors.white,
              ),
              _AdminStatCard(
                title: 'Active Users',
                value: userProvider.activeUsers.toString(),
                subtitle: 'Active users',
                icon: Icons.online_prediction_rounded,
                color: Colors.white,
              ),
              _AdminStatCard(
                title: 'Total Topics',
                value: quizProvider.topics.length.toString(),
                subtitle: 'Available topics',
                icon: Icons.category_rounded,
                color: Colors.white,
              ),
              _AdminStatCard(
                title: 'Total Questions',
                value: quizProvider.topics.fold(0, (sum, topic) => sum + topic.questionsCount).toString(),
                subtitle: 'All questions',
                icon: Icons.quiz_rounded,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            children: [
              _AdminActionCard(
                title: 'Add Topic',
                icon: Icons.add_rounded,
                color: Colors.white,
                onTap: () => _showAddTopicDialog(context),
              ),
              _AdminActionCard(
                title: 'Add Questions',
                icon: Icons.question_answer_rounded,
                color: Colors.white,
                onTap: () => _showAddQuestionsDialog(context),
              ),
              _AdminActionCard(
                title: 'Manage Users',
                icon: Icons.people_rounded,
                color: Colors.white,
                onTap: () {
                  final adminState = context.findAncestorStateOfType<_AdminDashboardScreenState>();
                  adminState?.setState(() {
                    adminState._currentIndex = 1;
                  });
                },
              ),
              _AdminActionCard(
                title: 'View Analytics',
                icon: Icons.analytics_rounded,
                color: Colors.white,
                onTap: () {
                  final adminState = context.findAncestorStateOfType<_AdminDashboardScreenState>();
                  adminState?.setState(() {
                    adminState._currentIndex = 3;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTopicDialog(),
    ).then((result) {
      if (result != null && result is String) {
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        final quizProvider = Provider.of<QuizProvider>(context, listen: false);
        
        final notification = AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'New Quiz Available!',
          message: 'A new quiz on "$result" has been added',
          type: NotificationType.quizAdded,
          timestamp: DateTime.now(),
          isRead: false,
          data: {
            'topicName': result,
            'adminName': 'System Admin',
          },
        );
        
        notificationProvider.addNotification(notification);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Topic "$result" added successfully! Students will be notified.', style: const TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        quizProvider.loadTopics();
      }
    });
  }

  void _showAddQuestionsDialog(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    if (quizProvider.topics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please create topics first before adding questions', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AddQuestionsDialog(topics: quizProvider.topics),
    ).then((result) {
      if (result != null && result is Map<String, dynamic>) {
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        
        final notification = AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Quiz Updated',
          message: 'New questions added to "${result['topic']}"',
          type: NotificationType.quizAdded,
          timestamp: DateTime.now(),
          isRead: false,
          data: {
            'topicName': result['topic'],
            'questionCount': result['questionCount'],
          },
        );
        
        notificationProvider.addNotification(notification);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Questions added to "${result['topic']}"!', style: const TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        quizProvider.loadTopics();
      }
    });
  }
}

class _AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _AdminStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.grey[900],
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('User Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => userProvider.loadUsers(),
          ),
        ],
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : userProvider.users.isEmpty
              ? const Center(child: Text('No users found', style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.users[index];
                    final isCurrentUser = user.email == authProvider.user?.email;
                    
                    return Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(user.initial, style: const TextStyle(color: Colors.black)),
                        ),
                        title: Text(
                          user.displayName, 
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal
                          )
                        ),
                        subtitle: Text(
                          '${user.email} • ${user.role}${isCurrentUser ? ' (You)' : ''}', 
                          style: TextStyle(color: Colors.grey[400])
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isCurrentUser) ...[
                              IconButton(
                                icon: Icon(
                                  user.isActive ? Icons.toggle_on : Icons.toggle_off,
                                  color: user.isActive ? Colors.green : Colors.grey,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _showToggleUserStatusDialog(context, userProvider, user);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteUserDialog(context, userProvider, user),
                              ),
                            ] else ...[
                              IconButton(
                                icon: const Icon(Icons.toggle_on, color: Colors.green),
                                onPressed: null,
                                tooltip: 'Cannot deactivate your own account',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey),
                                onPressed: null,
                                tooltip: 'Cannot delete your own account',
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showToggleUserStatusDialog(BuildContext context, UserProvider userProvider, User user) {
    final newStatus = !user.isActive;
    final action = newStatus ? 'activate' : 'deactivate';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('$action User', style: const TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to $action ${user.displayName}?', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              userProvider.toggleUserStatus(user.id, newStatus);
              Navigator.pop(context);
            },
            child: Text(action.capitalize(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(BuildContext context, UserProvider userProvider, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete User', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete ${user.displayName}? This action cannot be undone.', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              userProvider.deleteUser(user.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class ContentManagementScreen extends StatelessWidget {
  const ContentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Content Management', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Topics'),
              Tab(text: 'Questions'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => quizProvider.loadTopics(),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildTopicsTab(quizProvider),
            _buildQuestionsTab(quizProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicsTab(QuizProvider quizProvider) {
    return quizProvider.isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : quizProvider.topics.isEmpty
            ? const Center(child: Text('No topics found', style: TextStyle(color: Colors.white)))
            : ListView.builder(
                itemCount: quizProvider.topics.length,
                itemBuilder: (context, index) {
                  final topic = quizProvider.topics[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(topic.icon, style: const TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                      title: Text(topic.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${topic.difficultyText} • ${topic.questionsCount} questions • ${topic.estimatedTime} min', 
                              style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          if (topic.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              topic.description,
                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddTopicDialog(topic: topic),
                              ).then((_) {
                                quizProvider.loadTopics();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteTopicDialog(context, quizProvider, topic),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }

  Widget _buildQuestionsTab(QuizProvider quizProvider) {
    final allQuestions = <Map<String, dynamic>>[];
    
    for (final topic in quizProvider.topics) {
      for (final question in topic.questions) {
        allQuestions.add({
          'question': question,
          'topic': topic,
        });
      }
    }

    return quizProvider.isLoading
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : allQuestions.isEmpty
            ? const Center(child: Text('No questions found', style: TextStyle(color: Colors.white)))
            : ListView.builder(
                itemCount: allQuestions.length,
                itemBuilder: (context, index) {
                  final item = allQuestions[index];
                  final question = item['question'] as Question;
                  final topic = item['topic'] as Topic;
                  
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text('${index + 1}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(
                        question.questionText,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Topic: ${topic.name}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          Text('Correct Answer: ${question.options[question.correctAnswer]}', 
                              style: TextStyle(color: Colors.green[300], fontSize: 11)),
                          Text('Difficulty: ${question.difficulty}', 
                              style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.blue),
                        onPressed: () {
                          _showQuestionDetails(context, question, topic);
                        },
                      ),
                    ),
                  );
                },
              );
  }

  void _showQuestionDetails(BuildContext context, Question question, Topic topic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Question Details', style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Topic: ${topic.name}', style: TextStyle(color: Colors.grey[400])),
              const SizedBox(height: 8),
              Text('Question:', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(question.questionText, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              Text('Options:', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ...question.options.asMap().entries.map((entry) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${String.fromCharCode(65 + entry.key)}. ${entry.value}',
                    style: TextStyle(
                      color: entry.key == question.correctAnswer ? Colors.green : Colors.white,
                      fontWeight: entry.key == question.correctAnswer ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                )
              ),
              const SizedBox(height: 8),
              Text('Difficulty: ${question.difficulty}', style: TextStyle(color: Colors.grey[400])),
              Text('Explanation: ${question.explanation}', style: TextStyle(color: Colors.grey[400])),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteTopicDialog(BuildContext context, QuizProvider quizProvider, Topic topic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Delete Topic', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${topic.name}"? This will also delete all associated questions.', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              quizProvider.deleteTopic(topic.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Analytics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          
          // User Statistics Card
          Card(
            color: Colors.grey[900],
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.people_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'User Statistics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    children: [
                      _AnalyticsItem(
                        title: 'Total Users',
                        value: userProvider.totalUsers.toString(),
                        icon: Icons.people_alt_rounded,
                        color: Colors.blue,
                      ),
                      _AnalyticsItem(
                        title: 'Active Users',
                        value: userProvider.activeUsers.toString(),
                        icon: Icons.online_prediction_rounded,
                        color: Colors.green,
                      ),
                      _AnalyticsItem(
                        title: 'Admin Users',
                        value: userProvider.users.where((user) => user.role == 'admin').length.toString(),
                        icon: Icons.admin_panel_settings_rounded,
                        color: Colors.orange,
                      ),
                      _AnalyticsItem(
                        title: 'Student Users',
                        value: userProvider.users.where((user) => user.role == 'student').length.toString(),
                        icon: Icons.school_rounded,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Content Statistics Card
          Card(
            color: Colors.grey[900],
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.library_books_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Content Statistics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    children: [
                      _AnalyticsItem(
                        title: 'Total Topics',
                        value: quizProvider.topics.length.toString(),
                        icon: Icons.category_rounded,
                        color: Colors.red,
                      ),
                      _AnalyticsItem(
                        title: 'Total Questions',
                        value: quizProvider.topics.fold(0, (sum, topic) => sum + topic.questionsCount).toString(),
                        icon: Icons.quiz_rounded,
                        color: Colors.teal,
                      ),
                      _AnalyticsItem(
                        title: 'Avg Questions/Topic',
                        value: quizProvider.topics.isEmpty ? '0' : (quizProvider.topics.fold(0, (sum, topic) => sum + topic.questionsCount) / quizProvider.topics.length).toStringAsFixed(1),
                        icon: Icons.analytics_rounded,
                        color: Colors.yellow,
                      ),
                      _AnalyticsItem(
                        title: 'Difficulty Levels',
                        value: quizProvider.topics.map((topic) => topic.difficulty).toSet().length.toString(),
                        icon: Icons.folder_rounded,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Topic Breakdown Card
          Card(
            color: Colors.grey[900],
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pie_chart_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Topic Breakdown',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...quizProvider.topics.map((topic) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[700]!),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(topic.icon, style: const TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                        title: Text(
                          topic.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              topic.description.isNotEmpty ? topic.description : 'No description',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _TopicChip(text: topic.difficultyText, color: _getDifficultyColor(topic.difficulty)),
                                const SizedBox(width: 8),
                                _TopicChip(text: '${topic.questionsCount} questions', color: Colors.blue),
                                const SizedBox(width: 8),
                                _TopicChip(text: '${topic.estimatedTime} min', color: Colors.green),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${topic.questionsCount}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'questions',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _AnalyticsItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AnalyticsItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String text;
  final Color color;

  const _TopicChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}