import 'package:flutter/material.dart';
import 'package:cybersecurity_quiz_app/models/campus_alert_model.dart';

class CampusAlertsScreen extends StatefulWidget {
  const CampusAlertsScreen({super.key});

  @override
  State<CampusAlertsScreen> createState() => _CampusAlertsScreenState();
}

class _CampusAlertsScreenState extends State<CampusAlertsScreen> {
  final List<CampusAlert> _alerts = [
    CampusAlert(
      id: '1',
      title: 'Phishing Campaign Targeting Students',
      description: 'Reports of fake scholarship emails asking for personal information. Do not click links or provide any details.',
      type: AlertType.warning,
      issuedAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      isActive: true,
    ),
    CampusAlert(
      id: '2',
      title: 'Public Wi-Fi Security Update',
      description: 'Always use VPN when connecting to campus Wi-Fi for sensitive activities like online banking.',
      type: AlertType.info,
      issuedAt: DateTime.now().subtract(const Duration(days: 1)),
      isActive: true,
    ),
    CampusAlert(
      id: '3',
      title: 'Two-Factor Authentication Enabled',
      description: 'University now supports 2FA for all student accounts. Enable it in your account settings.',
      type: AlertType.success,
      issuedAt: DateTime.now().subtract(const Duration(days: 3)),
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Security Alerts'),
      ),
      body: _alerts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_rounded, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No active alerts', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _alerts.length,
              itemBuilder: (context, index) {
                final alert = _alerts[index];
                return CampusAlertCard(alert: alert);
              },
            ),
    );
  }
}

class CampusAlertCard extends StatelessWidget {
  final CampusAlert alert;

  const CampusAlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: alert.alertColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(alert.alertIcon, color: alert.alertColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: alert.alertColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Issued: ${_formatTime(alert.issuedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
  }
}