class SecurityChecklist {
  final String id;
  final String title;
  final String description;
  final List<ChecklistItem> items;
  final bool isCompleted;

  SecurityChecklist({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    this.isCompleted = false,
  });

  double get progress {
    if (items.isEmpty) return 0.0;
    final completed = items.where((item) => item.isCompleted).length;
    return completed / items.length;
  }
}

class ChecklistItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final int points;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.points,
    this.isCompleted = false,
  });
}