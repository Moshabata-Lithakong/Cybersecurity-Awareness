import 'package:flutter/foundation.dart';
import 'package:cybersecurity_quiz_app/models/offline_resource_model.dart';
import 'package:cybersecurity_quiz_app/services/download_service.dart';

class ResourcesProvider with ChangeNotifier {
  final DownloadService _downloadService;
  final List<OfflineResource> _offlineResources = [];
  final List<ExternalResource> _externalResources = [];

  ResourcesProvider(this._downloadService) {
    _loadOfflineResources();
    _loadExternalResources();
  }

  List<OfflineResource> get offlineResources => _offlineResources;
  List<ExternalResource> get externalResources => _externalResources;

  List<OfflineResource> get downloadedResources {
    return _offlineResources.where((resource) {
      return _downloadService.isDownloaded(resource.id);
    }).toList();
  }

  void _loadOfflineResources() {
    _offlineResources.addAll([
      OfflineResource(
        id: '1',
        title: 'Cybersecurity Fundamentals Guide',
        description: 'Complete beginner guide to cybersecurity principles and best practices',
        type: ResourceType.pdf,
        fileUrl: 'https://www.cyber.gov.au/sites/default/files/2023-02/cyber-security-guidelines.pdf',
        fileSize: '2.3 MB',
        estimatedReadingTime: 45,
        category: 'Fundamentals',
        icon: '📚',
      ),
      OfflineResource(
        id: '2',
        title: 'Password Security Cheat Sheet',
        description: 'Quick reference for creating and managing secure passwords',
        type: ResourceType.cheatSheet,
        fileUrl: 'https://www.ncsc.gov.uk/guidance/password-guidance-simplifying-your-approach',
        fileSize: '1.1 MB',
        estimatedReadingTime: 15,
        category: 'Authentication',
        icon: '🔐',
      ),
      OfflineResource(
        id: '3',
        title: 'Phishing Detection Quiz',
        description: 'Interactive quiz to test your phishing email detection skills',
        type: ResourceType.interactive,
        fileUrl: 'https://example.com/phishing-quiz.json',
        fileSize: '0.8 MB',
        estimatedReadingTime: 20,
        category: 'Social Engineering',
        icon: '🎣',
      ),
      OfflineResource(
        id: '4',
        title: 'Network Security Basics',
        description: 'Essential network security concepts and protocols',
        type: ResourceType.pdf,
        fileUrl: 'https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-53r5.pdf',
        fileSize: '3.2 MB',
        estimatedReadingTime: 60,
        category: 'Network Security',
        icon: '🌐',
      ),
      OfflineResource(
        id: '5',
        title: 'Mobile Security Checklist',
        description: 'Comprehensive checklist for securing mobile devices',
        type: ResourceType.cheatSheet,
        fileUrl: 'https://www.cisa.gov/sites/default/files/publications/rooting_out_mobile_malware_508.pdf',
        fileSize: '0.9 MB',
        estimatedReadingTime: 10,
        category: 'Mobile Security',
        icon: '📱',
      ),
      OfflineResource(
        id: '6',
        title: 'Incident Response Guide',
        description: 'Step-by-step guide for security incident response',
        type: ResourceType.pdf,
        fileUrl: 'https://www.cisa.gov/sites/default/files/publications/incident-response-guide_508c.pdf',
        fileSize: '2.8 MB',
        estimatedReadingTime: 50,
        category: 'Incident Response',
        icon: '🚨',
      ),
    ]);
  }

  void _loadExternalResources() {
    _externalResources.addAll([
      ExternalResource(
        id: 'ext1',
        title: 'Cybersecurity & Infrastructure Security Agency (CISA)',
        description: 'Official US government cybersecurity resources and alerts',
        url: 'https://www.cisa.gov/cybersecurity',
        category: 'Government Resources',
        icon: '🇺🇸',
        level: ResourceLevel.beginner,
        isFree: true,
        estimatedTime: 'Varies',
      ),
      ExternalResource(
        id: 'ext2',
        title: 'OWASP Foundation',
        description: 'Open Web Application Security Project - community-led resources',
        url: 'https://owasp.org',
        category: 'Web Security',
        icon: '🕸️',
        level: ResourceLevel.intermediate,
        isFree: true,
        estimatedTime: 'Varies',
      ),
      ExternalResource(
        id: 'ext3',
        title: 'Khan Academy - Online Security',
        description: 'Free courses on internet safety and online security',
        url: 'https://www.khanacademy.org',
        category: 'Online Learning',
        icon: '🎓',
        level: ResourceLevel.beginner,
        isFree: true,
        estimatedTime: '10+ hours',
      ),
      ExternalResource(
        id: 'ext4',
        title: 'Coursera - Cybersecurity Specializations',
        description: 'Professional cybersecurity courses from top universities',
        url: 'https://www.coursera.org',
        category: 'Professional Courses',
        icon: '💼',
        level: ResourceLevel.advanced,
        isFree: false,
        estimatedTime: '20+ hours',
      ),
      ExternalResource(
        id: 'ext5',
        title: 'YouTube - NetworkChuck',
        description: 'Popular cybersecurity tutorials and ethical hacking guides',
        url: 'https://www.youtube.com/c/NetworkChuck',
        category: 'Video Tutorials',
        icon: '🎥',
        level: ResourceLevel.intermediate,
        isFree: true,
        estimatedTime: '50+ hours',
      ),
      ExternalResource(
        id: 'ext6',
        title: 'GitHub - Awesome Cybersecurity',
        description: 'Curated list of cybersecurity tools and resources',
        url: 'https://github.com',
        category: 'Tools & Resources',
        icon: '⚙️',
        level: ResourceLevel.expert,
        isFree: true,
        estimatedTime: 'Varies',
      ),
      ExternalResource(
        id: 'ext7',
        title: 'TryHackMe',
        description: 'Hands-on cybersecurity learning through real-world scenarios',
        url: 'https://tryhackme.com',
        category: 'Hands-on Practice',
        icon: '🎯',
        level: ResourceLevel.intermediate,
        isFree: true,
        estimatedTime: '100+ hours',
      ),
      ExternalResource(
        id: 'ext8',
        title: 'HackTheBox',
        description: 'Advanced penetration testing labs and challenges',
        url: 'https://www.hackthebox.com',
        category: 'Penetration Testing',
        icon: '🎪',
        level: ResourceLevel.advanced,
        isFree: true,
        estimatedTime: '200+ hours',
      ),
    ]);
  }

  Future<void> downloadResource(OfflineResource resource) async {
    try {
      final filename = '${resource.id}_${resource.title.replaceAll(' ', '_')}.${_getFileExtension(resource.type)}';
      
      await _downloadService.downloadResource(
        resourceId: resource.id,
        url: resource.fileUrl,
        filename: filename,
      );
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDownloadedResource(OfflineResource resource) async {
    try {
      final filename = '${resource.id}_${resource.title.replaceAll(' ', '_')}.${_getFileExtension(resource.type)}';
      await _downloadService.deleteResource(resource.id, filename);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  String _getFileExtension(ResourceType type) {
    switch (type) {
      case ResourceType.pdf:
        return 'pdf';
      case ResourceType.video:
        return 'mp4';
      case ResourceType.quiz:
        return 'json';
      case ResourceType.cheatSheet:
        return 'pdf';
      case ResourceType.interactive:
        return 'html';
      case ResourceType.audio:
        return 'mp3';
    }
  }

  double getDownloadProgress(String resourceId) {
    return _downloadService.getDownloadProgress(resourceId);
  }

  bool isResourceDownloaded(String resourceId) {
    return _downloadService.isDownloaded(resourceId);
  }

  void updateResourceLastAccessed(String resourceId) {
    final index = _offlineResources.indexWhere((r) => r.id == resourceId);
    if (index != -1) {
      notifyListeners();
    }
  }
}