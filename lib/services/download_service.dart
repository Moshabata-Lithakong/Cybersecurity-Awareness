import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DownloadService with ChangeNotifier {
  final Map<String, double> _downloadProgress = {};
  final Map<String, bool> _downloadComplete = {};
  final Map<String, String> _localPaths = {};

  // Get download progress for a resource
  double getDownloadProgress(String resourceId) {
    return _downloadProgress[resourceId] ?? 0.0;
  }

  // Check if resource is downloaded
  bool isDownloaded(String resourceId) {
    return _downloadComplete[resourceId] ?? false;
  }

  // Get local file path for downloaded resource
  String? getLocalPath(String resourceId) {
    return _localPaths[resourceId];
  }

  // Check if download is in progress
  bool isDownloading(String resourceId) {
    return _downloadProgress.containsKey(resourceId);
  }

  // Download resource with web and mobile support
  Future<void> downloadResource({
    required String resourceId,
    required String url,
    required String filename,
  }) async {
    try {
      _downloadProgress[resourceId] = 0.0;
      _downloadComplete[resourceId] = false;
      notifyListeners();

      if (kIsWeb) {
        // Web platform: simulate download with progress
        await _simulateWebDownload(resourceId, filename, url);
      } else {
        // Mobile platform: actual file download
        await _downloadMobileFile(resourceId, url, filename);
      }

      _downloadComplete[resourceId] = true;
      _downloadProgress.remove(resourceId);
      notifyListeners();

    } catch (e) {
      _downloadProgress.remove(resourceId);
      _downloadComplete[resourceId] = false;
      notifyListeners();
      rethrow;
    }
  }

  // Web download simulation
  Future<void> _simulateWebDownload(String resourceId, String filename, String url) async {
    // Simulate download progress
    for (int i = 0; i <= 100; i += 20) {
      await Future.delayed(const Duration(milliseconds: 200));
      _downloadProgress[resourceId] = i / 100.0;
      notifyListeners();
    }

    // Store download info in shared preferences for web
    final prefs = await SharedPreferences.getInstance();
    final downloadedResources = prefs.getStringList('downloaded_resources') ?? [];
    if (!downloadedResources.contains(resourceId)) {
      downloadedResources.add(resourceId);
      await prefs.setStringList('downloaded_resources', downloadedResources);
    }

    // Store detailed resource info
    await prefs.setString('resource_$resourceId', json.encode({
      'filename': filename,
      'url': url,
      'downloadedAt': DateTime.now().toIso8601String(),
    }));
  }

  // Mobile file download
  Future<void> _downloadMobileFile(String resourceId, String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      // Update progress
      _downloadProgress[resourceId] = 0.5;
      notifyListeners();

      // Save file locally
      final file = await _localFile(filename);
      await file.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
      
      // Store local path
      _localPaths[resourceId] = file.path;

      // Update progress to complete
      _downloadProgress[resourceId] = 1.0;
      notifyListeners();

    } else {
      throw Exception('Download failed with status: ${response.statusCode}');
    }
  }

  // Delete downloaded resource
  Future<void> deleteResource(String resourceId, String filename) async {
    try {
      if (!kIsWeb) {
        // Mobile: delete physical file
        final file = await _localFile(filename);
        if (await file.exists()) {
          await file.delete();
        }
        _localPaths.remove(resourceId);
      } else {
        // Web: remove from shared preferences
        final prefs = await SharedPreferences.getInstance();
        final downloadedResources = prefs.getStringList('downloaded_resources') ?? [];
        downloadedResources.remove(resourceId);
        await prefs.setStringList('downloaded_resources', downloadedResources);
        
        // Remove resource info
        await prefs.remove('resource_$resourceId');
      }

      _downloadComplete.remove(resourceId);
      notifyListeners();

    } catch (e) {
      rethrow;
    }
  }

  // Cancel ongoing download
  void cancelDownload(String resourceId) {
    _downloadProgress.remove(resourceId);
    _downloadComplete.remove(resourceId);
    notifyListeners();
  }

  // Get list of downloaded files
  Future<List<String>> getDownloadedFiles() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList('downloaded_resources') ?? [];
    } else {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final resourcesDir = Directory('${directory.path}/offline_resources');
        
        if (await resourcesDir.exists()) {
          final files = await resourcesDir.list().toList();
          return files.whereType<File>().map((file) => file.path).toList();
        }
        return [];
      } catch (e) {
        if (kDebugMode) {
          print('Error getting downloaded files: $e');
        }
        return [];
      }
    }
  }

  // Get total size of all downloads
  Future<int> getTotalDownloadedSize() async {
    if (kIsWeb) {
      return 0; // Web doesn't have direct file size access
    } else {
      try {
        int totalSize = 0;
        for (final path in _localPaths.values) {
          final file = File(path);
          if (await file.exists()) {
            totalSize += await file.length();
          }
        }
        return totalSize;
      } catch (e) {
        return 0;
      }
    }
  }

  // Clear all downloads
  Future<void> clearAllDownloads() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('downloaded_resources');
        
        // Remove all resource info
        final keys = prefs.getKeys();
        for (final key in keys) {
          if (key.startsWith('resource_')) {
            await prefs.remove(key);
          }
        }
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final resourcesDir = Directory('${directory.path}/offline_resources');
        
        if (await resourcesDir.exists()) {
          await resourcesDir.delete(recursive: true);
        }
      }
      
      _downloadComplete.clear();
      _localPaths.clear();
      _downloadProgress.clear();
      notifyListeners();
      
    } catch (e) {
      rethrow;
    }
  }

  // Open downloaded file (mobile) or return success (web)
  Future<bool> openDownloadedFile(String resourceId) async {
    try {
      if (kIsWeb) {
        // For web, we consider it "opened" since it's in browser storage
        return true;
      } else {
        final localPath = _localPaths[resourceId];
        if (localPath != null) {
          final file = File(localPath);
          return await file.exists();
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error opening file: $e');
      }
      return false;
    }
  }

  // Get local file path for mobile
  Future<File> _localFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/offline_resources/$filename');
  }

  // Get downloaded resource info for web
  Future<Map<String, dynamic>?> getResourceInfo(String resourceId) async {
    if (kIsWeb) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final infoJson = prefs.getString('resource_$resourceId');
        if (infoJson != null) {
          return json.decode(infoJson) as Map<String, dynamic>;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error getting resource info: $e');
        }
      }
    }
    return null;
  }

  // Get all downloaded resource IDs
  List<String> getDownloadedResourceIds() {
    return _downloadComplete.keys.where((id) => _downloadComplete[id] == true).toList();
  }

  // Check storage availability (fixed version)
  Future<bool> checkStorageAvailability() async {
    if (kIsWeb) {
      return true; // Web generally has storage via SharedPreferences
    } else {
      try {
        final directory = await getApplicationDocumentsDirectory();
        // For mobile, we'll assume storage is available if we can access the directory
        // This is a simplified check - in production you might want more sophisticated storage checking
        return await directory.exists();
      } catch (e) {
        return false;
      }
    }
  }

  // Get download status summary
  Map<String, dynamic> getDownloadStatus(String resourceId) {
    return {
      'isDownloaded': isDownloaded(resourceId),
      'isDownloading': isDownloading(resourceId),
      'progress': getDownloadProgress(resourceId),
      'localPath': getLocalPath(resourceId),
    };
  }

  // Initialize service - load existing downloads
  Future<void> initialize() async {
    if (!kIsWeb) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final resourcesDir = Directory('${directory.path}/offline_resources');
        
        if (await resourcesDir.exists()) {
          final files = await resourcesDir.list().toList();
          for (final file in files.whereType<File>()) {
            // Extract resource ID from filename (assuming format: {id}_{title}.{ext})
            final filename = file.uri.pathSegments.last;
            final resourceId = filename.split('_').first;
            _localPaths[resourceId] = file.path;
            _downloadComplete[resourceId] = true;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing download service: $e');
        }
      }
    }
    notifyListeners();
  }
}