import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/auth_provider.dart';
import 'package:cybersecurity_quiz_app/providers/quiz_provider.dart';
import 'package:cybersecurity_quiz_app/providers/user_provider.dart';
import 'package:cybersecurity_quiz_app/providers/notification_provider.dart';
import 'package:cybersecurity_quiz_app/screens/topics_screen.dart';
import 'package:cybersecurity_quiz_app/screens/progress_screen.dart';
import 'package:cybersecurity_quiz_app/screens/profile_screen.dart';
import 'package:cybersecurity_quiz_app/screens/ai_assistant_screen.dart';
import 'package:cybersecurity_quiz_app/screens/security_checklist_screen.dart';
import 'package:cybersecurity_quiz_app/screens/resources_screen.dart';
import 'package:cybersecurity_quiz_app/screens/landing_screen.dart';
import 'package:cybersecurity_quiz_app/models/topic_model.dart';
import 'package:cybersecurity_quiz_app/models/user_activity_model.dart';
import 'package:cybersecurity_quiz_app/models/notification_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  final List<Widget> _screens = [
    const HomeDashboard(),
    const TopicsScreen(),
    const AIAssistantScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
    const ResourcesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    
    try {
      await Future.wait([
        quizProvider.loadTopics(),
        userProvider.loadUserProgress(),
        userProvider.loadRecentActivities(),
        notificationProvider.loadNotifications(),
      ]);
    } catch (e) {
      print('Error loading initial data: $e');
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    
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
              'CyberGuard LK',
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded, color: Colors.white),
                onPressed: () => _showNotifications(context),
              ),
              if (notificationProvider.hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      notificationProvider.unreadCount > 9 
                          ? '9+' 
                          : notificationProvider.unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading your dashboard...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ) 
          : _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  void _goBackToLanding(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingScreen()),
      (route) => false,
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz_rounded),
          activeIcon: Icon(Icons.quiz),
          label: 'Quiz',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assistant_rounded),
          activeIcon: Icon(Icons.assistant),
          label: 'AI Assistant',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_rounded),
          activeIcon: Icon(Icons.analytics),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download_rounded),
          activeIcon: Icon(Icons.download_done_rounded),
          label: 'Resources',
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => NotificationBottomSheet(
        notificationProvider: notificationProvider,
      ),
    );
  }
}

class NotificationBottomSheet extends StatelessWidget {
  final NotificationProvider notificationProvider;

  const NotificationBottomSheet({
    super.key,
    required this.notificationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (notificationProvider.unreadCount > 0)
                TextButton(
                  onPressed: () {
                    notificationProvider.markAllAsRead();
                  },
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: notificationProvider.notifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_rounded, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No notifications',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: notificationProvider.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notificationProvider.notifications[index];
                      return NotificationItem(
                        notification: notification,
                        onTap: () {
                          notificationProvider.markAsRead(notification.id);
                          _handleNotificationTap(context, notification);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, AppNotification notification) {
    Navigator.pop(context);
    
    if (notification.type == NotificationType.quizAdded) {
      final homeState = context.findAncestorStateOfType<_HomeScreenState>();
      homeState?.setState(() {
        homeState._currentIndex = 1;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New quiz: ${notification.message}', style: const TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.isRead ? Colors.grey[900] : Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(notification.icon, color: Colors.white),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: notification.isRead ? 14 : 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: notification.isRead ? 12 : 13,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.timeAgo,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final quizProvider = Provider.of<QuizProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        backgroundColor: Colors.black,
        color: Colors.white,
        onRefresh: () async {
          await userProvider.loadUserProgress();
          await userProvider.loadRecentActivities();
          await notificationProvider.loadNotifications();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(authProvider),
              const SizedBox(height: 24),
              _buildNewQuizzesSection(quizProvider, notificationProvider, context),
              if (notificationProvider.notifications.any((n) => n.type == NotificationType.quizAdded && !n.isRead))
                const SizedBox(height: 24),
              _buildDailyChallenge(context),
              const SizedBox(height: 24),
              _buildStatsSection(userProvider),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentActivities(userProvider),
              const SizedBox(height: 24),
              _buildRecommendedTopics(quizProvider, context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d), Color(0xFF1a1a1a)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.security_rounded, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${authProvider.user?.username ?? 'Cyber Warrior'}! 🛡️',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Continue your cybersecurity learning journey',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  '70% of weekly goal completed',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewQuizzesSection(QuizProvider quizProvider, NotificationProvider notificationProvider, BuildContext context) {
    final newQuizNotifications = notificationProvider.notifications
        .where((n) => n.type == NotificationType.quizAdded && !n.isRead)
        .toList();

    if (newQuizNotifications.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'New Content 🎉',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        ...newQuizNotifications.take(2).map((notification) => Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.new_releases_rounded, color: Colors.white),
            ),
            title: Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
            subtitle: Text(
              notification.message,
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            onTap: () {
              notificationProvider.markAsRead(notification.id);
              final homeState = context.findAncestorStateOfType<_HomeScreenState>();
              homeState?.setState(() {
                homeState._currentIndex = 1;
              });
            },
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildDailyChallenge(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: const Icon(Icons.emoji_events_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Challenge',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete a 5-question quiz on Password Security',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TopicsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
              ),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          children: [
            _StatCard(
              title: 'Quizzes Completed',
              value: userProvider.progressStats?.totalQuizzesTaken.toString() ?? '0',
              subtitle: 'Total attempts',
              icon: Icons.quiz_rounded,
              color: Colors.white,
              progress: 0.8,
            ),
            _StatCard(
              title: 'Average Score',
              value: '${userProvider.progressStats?.averageScore.toStringAsFixed(1) ?? '0'}%',
              subtitle: 'Performance',
              icon: Icons.analytics_rounded,
              color: Colors.white,
              progress: 0.75,
            ),
            _StatCard(
              title: 'Accuracy Rate',
              value: '${userProvider.progressStats?.accuracy.toStringAsFixed(1) ?? '0'}%',
              subtitle: 'Correct answers',
              icon: Icons.track_changes_rounded,
              color: Colors.white,
              progress: 0.85,
            ),
            _StatCard(
              title: 'Learning Streak',
              value: '${userProvider.progressStats?.learningStreak ?? 0} days',
              subtitle: 'Current streak',
              icon: Icons.local_fire_department_rounded,
              color: Colors.white,
              progress: 0.6,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivities(UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full activities screen
              },
              child: const Text(
                'View All',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (userProvider.recentActivities.isEmpty)
          _buildEmptyState(
            icon: Icons.history_rounded,
            title: 'No activities yet',
            subtitle: 'Complete your first quiz to see activities here',
          )
        else
          Column(
            children: userProvider.recentActivities
                .take(3)
                .map((activity) => _ActivityItem(activity: activity))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          children: [
            _ActionCard(
              title: 'Take Quiz',
              subtitle: 'Test your knowledge',
              icon: Icons.quiz_rounded,
              gradient: [Colors.grey[900]!, Colors.grey[800]!],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TopicsScreen()),
                );
              },
            ),
            _ActionCard(
              title: 'Security Scan',
              subtitle: 'Check your safety',
              icon: Icons.security_rounded,
              gradient: [Colors.grey[900]!, Colors.grey[800]!],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecurityChecklistScreen()),
                );
              },
            ),
            _ActionCard(
              title: 'AI Assistant',
              subtitle: 'Get help',
              icon: Icons.assistant_rounded,
              gradient: [Colors.grey[900]!, Colors.grey[800]!],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AIAssistantScreen()),
                );
              },
            ),
            _ActionCard(
              title: 'Resources',
              subtitle: 'Download materials',
              icon: Icons.download_rounded,
              gradient: [Colors.grey[900]!, Colors.grey[800]!],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ResourcesScreen()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendedTopics(QuizProvider quizProvider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recommended Topics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TopicsScreen()),
                );
              },
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (quizProvider.topics.isEmpty)
          _buildEmptyState(
            icon: Icons.quiz_outlined,
            title: 'No topics available',
            subtitle: 'Topics will be available soon',
          )
        else
          Column(
            children: quizProvider.topics
                .take(3)
                .map((topic) => _TopicCard(topic: topic))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
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
                  child: Icon(icon, size: 20, color: color),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
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
                fontSize: 14,
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
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final UserActivity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(_getActivityIcon(activity.type), size: 20, color: Colors.white),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        subtitle: Text(activity.subtitle, style: TextStyle(color: Colors.grey[400])),
        trailing: Text(
          _formatTime(activity.timestamp),
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.quizCompleted:
        return Icons.quiz_rounded;
      case ActivityType.topicMastered:
        return Icons.verified_rounded;
      case ActivityType.streakExtended:
        return Icons.local_fire_department_rounded;
      case ActivityType.profileUpdated:
        return Icons.person_rounded;
      default:
        return Icons.history_rounded;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: Colors.white),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final Topic topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(topic.icon, style: const TextStyle(fontSize: 18, color: Colors.white)),
        ),
        title: Text(topic.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(
          '${topic.questionsCount} questions • ${topic.difficultyText}',
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getDifficultyColor(topic.difficulty).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getDifficultyColor(topic.difficulty).withOpacity(0.5)),
          ),
          child: Text(
            topic.difficultyText,
            style: TextStyle(
              color: _getDifficultyColor(topic.difficulty),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        onTap: () {
          // Navigate to quiz screen for this topic
        },
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