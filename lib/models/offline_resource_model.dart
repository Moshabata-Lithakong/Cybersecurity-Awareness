class OfflineResource {
  final String id;
  final String title;
  final String description;
  final ResourceType type;
  final String fileUrl;
  final String fileSize;
  final int estimatedReadingTime; // in minutes
  final String category;
  final String icon;
  final bool isDownloaded;
  final String? localPath;
  final double downloadProgress;
  final DateTime? lastAccessed;

  OfflineResource({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.fileUrl,
    required this.fileSize,
    required this.estimatedReadingTime,
    required this.category,
    required this.icon,
    this.isDownloaded = false,
    this.localPath,
    this.downloadProgress = 0.0,
    this.lastAccessed,
  });

  OfflineResource copyWith({
    bool? isDownloaded,
    String? localPath,
    double? downloadProgress,
    DateTime? lastAccessed,
  }) {
    return OfflineResource(
      id: id,
      title: title,
      description: description,
      type: type,
      fileUrl: fileUrl,
      fileSize: fileSize,
      estimatedReadingTime: estimatedReadingTime,
      category: category,
      icon: icon,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPath: localPath ?? this.localPath,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      lastAccessed: lastAccessed ?? this.lastAccessed,
    );
  }
}

enum ResourceType {
  pdf,
  video,
  quiz,
  cheatSheet,
  interactive,
  audio,
}

class ExternalResource {
  final String id;
  final String title;
  final String description;
  final String url;
  final String category;
  final String icon;
  final ResourceLevel level;
  final bool isFree;
  final String estimatedTime;

  ExternalResource({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.category,
    required this.icon,
    required this.level,
    required this.isFree,
    required this.estimatedTime,
  });
}

enum ResourceLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}