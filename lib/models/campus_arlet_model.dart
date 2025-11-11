class CampusAlert {
  final String id;
  final String title;
  final String description;
  final AlertType type;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final bool isActive;

  CampusAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.issuedAt,
    this.expiresAt,
    required this.isActive,
  });

  factory CampusAlert.fromJson(Map<String, dynamic> json) {
    return CampusAlert(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: AlertType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AlertType.info,
      ),
      issuedAt: DateTime.parse(json['issuedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Color get alertColor {
    switch (type) {
      case AlertType.emergency:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
      case AlertType.success:
        return Colors.green;
    }
  }

  IconData get alertIcon {
    switch (type) {
      case AlertType.emergency:
        return Icons.warning_amber_rounded;
      case AlertType.warning:
        return Icons.warning_rounded;
      case AlertType.info:
        return Icons.info_rounded;
      case AlertType.success:
        return Icons.check_circle_rounded;
    }
  }
}

enum AlertType {
  emergency,
  warning,
  info,
  success,
}