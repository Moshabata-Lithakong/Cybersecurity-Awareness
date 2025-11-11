import 'package:flutter/material.dart';
import 'package:cybersecurity_quiz_app/models/security_checklist_model.dart';

class SecurityChecklistScreen extends StatefulWidget {
  const SecurityChecklistScreen({super.key});

  @override
  State<SecurityChecklistScreen> createState() => _SecurityChecklistScreenState();
}

class _SecurityChecklistScreenState extends State<SecurityChecklistScreen> {
  final List<SecurityChecklist> _checklists = [
    SecurityChecklist(
      id: '1',
      title: 'Student Account Security',
      description: 'Essential security measures for your university accounts',
      items: [
        ChecklistItem(
          id: '1-1',
          title: 'Enable Two-Factor Authentication',
          description: 'Add an extra layer of security to your student account',
          category: 'Authentication',
          points: 20,
        ),
        ChecklistItem(
          id: '1-2',
          title: 'Use Strong Password',
          description: 'Create a unique password with letters, numbers, and symbols',
          category: 'Passwords',
          points: 15,
        ),
        ChecklistItem(
          id: '1-3',
          title: 'Update Recovery Email',
          description: 'Ensure you have access to account recovery options',
          category: 'Recovery',
          points: 10,
        ),
      ],
    ),
    SecurityChecklist(
      id: '2',
      title: 'Social Media Privacy',
      description: 'Protect your personal information on social platforms',
      items: [
        ChecklistItem(
          id: '2-1',
          title: 'Review Privacy Settings',
          description: 'Adjust who can see your posts and personal information',
          category: 'Privacy',
          points: 15,
        ),
        ChecklistItem(
          id: '2-2',
          title: 'Remove Personal Address',
          description: 'Don\'t share your home or dorm location publicly',
          category: 'Location',
          points: 10,
        ),
        ChecklistItem(
          id: '2-3',
          title: 'Enable Login Alerts',
          description: 'Get notified of suspicious login attempts',
          category: 'Security',
          points: 15,
        ),
      ],
    ),
  ];

  void _toggleItem(String checklistId, String itemId) {
    setState(() {
      final checklist = _checklists.firstWhere((c) => c.id == checklistId);
      final item = checklist.items.firstWhere((i) => i.id == itemId);
      item.isCompleted = !item.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Security Checklist', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _checklists.length,
        itemBuilder: (context, index) {
          final checklist = _checklists[index];
          return ChecklistCard(
            checklist: checklist,
            onItemToggle: _toggleItem,
          );
        },
      ),
    );
  }
}

class ChecklistCard extends StatelessWidget {
  final SecurityChecklist checklist;
  final Function(String, String) onItemToggle;

  const ChecklistCard({
    super.key,
    required this.checklist,
    required this.onItemToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checklist.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        checklist.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                CircularProgressIndicator(
                  value: checklist.progress,
                  backgroundColor: Colors.grey[600],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    checklist.progress == 1.0 ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...checklist.items.map((item) => ChecklistItemRow(
                  item: item,
                  onTap: () => onItemToggle(checklist.id, item.id),
                )),
          ],
        ),
      ),
    );
  }
}

class ChecklistItemRow extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onTap;

  const ChecklistItemRow({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: item.isCompleted,
        onChanged: (_) => onTap(),
        fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.grey[600]!;
        }),
        checkColor: Colors.black,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          color: Colors.white,
        ),
      ),
      subtitle: Text(item.description, style: TextStyle(color: Colors.grey[400])),
      trailing: Chip(
        label: Text('+${item.points} pts', style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      onTap: onTap,
    );
  }
}