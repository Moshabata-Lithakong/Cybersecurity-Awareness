import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cybersecurity_quiz_app/providers/auth_provider.dart';
import 'package:cybersecurity_quiz_app/providers/user_provider.dart';
import 'package:cybersecurity_quiz_app/providers/settings_provider.dart';
import 'package:cybersecurity_quiz_app/screens/landing_screen.dart';
import 'package:cybersecurity_quiz_app/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      backgroundColor: settingsProvider.isDarkMode ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded, 
            color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: settingsProvider.isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit_rounded, 
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userProvider = Provider.of<UserProvider>(context);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(authProvider, settingsProvider),
                const SizedBox(height: 24),

                // Personal Information
                _buildPersonalInfo(authProvider, settingsProvider),
                const SizedBox(height: 24),

                // Security Settings
                _buildSecuritySettings(context, settingsProvider),
                const SizedBox(height: 24),

                // App Settings
                _buildAppSettings(settingsProvider),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider, SettingsProvider settingsProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: settingsProvider.isDarkMode 
              ? [Colors.grey[900]!, Colors.grey[800]!, Colors.grey[700]!]
              : [Colors.white, Colors.grey[100]!, Colors.grey[200]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: settingsProvider.isDarkMode 
                ? Colors.white.withOpacity(0.1) 
                : Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: settingsProvider.isDarkMode 
              ? Colors.white.withOpacity(0.2) 
              : Colors.black.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              shape: BoxShape.circle,
              border: Border.all(
                color: settingsProvider.isDarkMode ? Colors.white : Colors.black, 
                width: 2
              ),
            ),
            child: Icon(
              Icons.person_rounded,
              size: 40,
              color: settingsProvider.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            authProvider.user?.username ?? 'User',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            authProvider.user?.email ?? 'email@example.com',
            style: TextStyle(
              color: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              authProvider.user?.role?.toUpperCase() ?? 'STUDENT',
              style: TextStyle(
                color: settingsProvider.isDarkMode ? Colors.black : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(AuthProvider authProvider, SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: settingsProvider.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: settingsProvider.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: settingsProvider.isDarkMode 
                ? Colors.transparent 
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _ProfileInfoItem(
              icon: Icons.person_rounded,
              title: 'Username',
              value: authProvider.user?.username ?? 'N/A',
              settingsProvider: settingsProvider,
            ),
            _ProfileInfoItem(
              icon: Icons.email_rounded,
              title: 'Email',
              value: authProvider.user?.email ?? 'N/A',
              settingsProvider: settingsProvider,
            ),
            _ProfileInfoItem(
              icon: Icons.calendar_today_rounded,
              title: 'Member since',
              value: _formatDate(authProvider.user?.createdAt ?? DateTime.now()),
              settingsProvider: settingsProvider,
            ),
            _ProfileInfoItem(
              icon: Icons.verified_rounded,
              title: 'Account status',
              value: 'Verified',
              valueColor: Colors.green,
              settingsProvider: settingsProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: settingsProvider.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: settingsProvider.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: settingsProvider.isDarkMode 
                ? Colors.transparent 
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _SecuritySettingItem(
              title: 'Two-Factor Authentication',
              subtitle: 'Add extra security to your account',
              icon: Icons.verified_user_rounded,
              isEnabled: false,
              onToggle: (value) => _showFeatureDialog(context, 'Two-Factor Authentication', settingsProvider),
              settingsProvider: settingsProvider,
            ),
            _SecuritySettingItem(
              title: 'Login Notifications',
              subtitle: 'Get alerts for new logins',
              icon: Icons.notifications_rounded,
              isEnabled: true,
              onToggle: (value) => _showFeatureDialog(context, 'Login Notifications', settingsProvider),
              settingsProvider: settingsProvider,
            ),
            _SecuritySettingItem(
              title: 'Privacy Mode',
              subtitle: 'Hide your activity from others',
              icon: Icons.visibility_off_rounded,
              isEnabled: false,
              onToggle: (value) => _showFeatureDialog(context, 'Privacy Mode', settingsProvider),
              settingsProvider: settingsProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettings(SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: settingsProvider.isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: settingsProvider.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: settingsProvider.isDarkMode 
                ? Colors.transparent 
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _AppSettingItem(
              title: 'Dark Mode',
              subtitle: 'Use dark theme throughout the app',
              icon: Icons.dark_mode_rounded,
              isEnabled: settingsProvider.isDarkMode,
              onToggle: settingsProvider.toggleDarkMode,
              settingsProvider: settingsProvider,
            ),
            _AppSettingItem(
              title: 'Push Notifications',
              subtitle: 'Receive app notifications',
              icon: Icons.notifications_active_rounded,
              isEnabled: settingsProvider.pushNotifications,
              onToggle: settingsProvider.togglePushNotifications,
              settingsProvider: settingsProvider,
            ),
            _AppSettingItem(
              title: 'Data Saving',
              subtitle: 'Reduce data usage',
              icon: Icons.data_saver_off_rounded,
              isEnabled: settingsProvider.dataSaving,
              onToggle: settingsProvider.toggleDataSaving,
              settingsProvider: settingsProvider,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showFeatureDialog(BuildContext context, String featureName, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: settingsProvider.isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Feature Coming Soon',
          style: TextStyle(
            color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          '$featureName feature will be available in the next update.',
          style: TextStyle(
            color: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final SettingsProvider settingsProvider;

  const _ProfileInfoItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.settingsProvider,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              size: 18, 
              color: settingsProvider.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? (settingsProvider.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;
  final Function(bool) onToggle;
  final SettingsProvider settingsProvider;

  const _SecuritySettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
    required this.onToggle,
    required this.settingsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              size: 20, 
              color: settingsProvider.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: settingsProvider.isDarkMode ? Colors.white : Colors.black,
            activeTrackColor: settingsProvider.isDarkMode ? Colors.grey : Colors.grey[400],
            inactiveThumbColor: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[300],
            inactiveTrackColor: settingsProvider.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
        ],
      ),
    );
  }
}

class _AppSettingItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isEnabled;
  final Function(bool) onToggle;
  final SettingsProvider settingsProvider;

  const _AppSettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isEnabled,
    required this.onToggle,
    required this.settingsProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              size: 20, 
              color: settingsProvider.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: settingsProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: settingsProvider.isDarkMode ? Colors.white : Colors.black,
            activeTrackColor: settingsProvider.isDarkMode ? Colors.grey : Colors.grey[400],
            inactiveThumbColor: settingsProvider.isDarkMode ? Colors.grey[400] : Colors.grey[300],
            inactiveTrackColor: settingsProvider.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          ),
        ],
      ),
    );
  }
}