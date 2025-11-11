import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cybersecurity_quiz_app/providers/resources_provider.dart';
import 'package:cybersecurity_quiz_app/models/offline_resource_model.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Learning Resources', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Offline Materials'),
            Tab(text: 'External Resources'),
            Tab(text: 'Downloads'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OfflineResourcesTab(),
          ExternalResourcesTab(),
          DownloadsTab(),
        ],
      ),
    );
  }
}

class OfflineResourcesTab extends StatelessWidget {
  const OfflineResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = Provider.of<ResourcesProvider>(context);

    return Container(
      color: Colors.grey[900],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resourcesProvider.offlineResources.length,
        itemBuilder: (context, index) {
          final resource = resourcesProvider.offlineResources[index];
          return _OfflineResourceCard(resource: resource);
        },
      ),
    );
  }
}

class _OfflineResourceCard extends StatelessWidget {
  final OfflineResource resource;

  const _OfflineResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = Provider.of<ResourcesProvider>(context);
    final isDownloaded = resourcesProvider.isResourceDownloaded(resource.id);
    final downloadProgress = resourcesProvider.getDownloadProgress(resource.id);

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    resource.icon,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resource.description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ResourceChip(
                  icon: Icons.schedule,
                  text: '${resource.estimatedReadingTime} min',
                ),
                const SizedBox(width: 8),
                _ResourceChip(
                  icon: Icons.storage,
                  text: resource.fileSize,
                ),
                const SizedBox(width: 8),
                _ResourceChip(
                  icon: Icons.category,
                  text: resource.category,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isDownloaded)
              _buildDownloadedActions(context, resource)
            else if (downloadProgress > 0.0)
              _buildDownloadProgress(downloadProgress)
            else
              _buildDownloadButton(context, resource),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, OfflineResource resource) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _downloadResource(context, resource);
        },
        icon: const Icon(Icons.download_rounded, color: Colors.black),
        label: const Text('Download for Offline Use', style: TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDownloadProgress(double progress) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[600],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          'Downloading... ${(progress * 100).toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadedActions(BuildContext context, OfflineResource resource) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _openResource(context, resource);
            },
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            label: const Text('Open', style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            _deleteResource(context, resource);
          },
          icon: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
      ],
    );
  }

  void _downloadResource(BuildContext context, OfflineResource resource) async {
    try {
      await Provider.of<ResourcesProvider>(context, listen: false)
          .downloadResource(resource);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${resource.title} downloaded successfully!'),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openResource(BuildContext context, OfflineResource resource) async {
    try {
      final url = Uri.parse(resource.fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open ${resource.title}'),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening resource: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteResource(BuildContext context, OfflineResource resource) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text('Delete Resource', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${resource.title}"?', style: TextStyle(color: Colors.grey[300])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<ResourcesProvider>(context, listen: false)
            .deleteDownloadedResource(resource);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${resource.title} deleted successfully!'),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _ResourceChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ResourceChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white)),
      labelStyle: const TextStyle(fontSize: 12),
      avatar: Icon(icon, size: 14, color: Colors.white),
      backgroundColor: Colors.grey[700],
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class ExternalResourcesTab extends StatelessWidget {
  const ExternalResourcesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = Provider.of<ResourcesProvider>(context);

    return Container(
      color: Colors.grey[900],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resourcesProvider.externalResources.length,
        itemBuilder: (context, index) {
          final resource = resourcesProvider.externalResources[index];
          return _ExternalResourceCard(resource: resource);
        },
      ),
    );
  }
}

class _ExternalResourceCard extends StatelessWidget {
  final ExternalResource resource;

  const _ExternalResourceCard({required this.resource});

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    resource.icon,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resource.description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ResourceChip(
                  icon: Icons.schedule,
                  text: resource.estimatedTime,
                ),
                _ResourceChip(
                  icon: resource.isFree ? Icons.free_breakfast : Icons.payment,
                  text: resource.isFree ? 'Free' : 'Paid',
                ),
                _ResourceChip(
                  icon: Icons.star,
                  text: _getLevelText(resource.level),
                ),
                _ResourceChip(
                  icon: Icons.category,
                  text: resource.category,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _openExternalResource(context, resource);
                },
                icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                label: const Text('Visit Website', style: TextStyle(color: Colors.white)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelText(ResourceLevel level) {
    switch (level) {
      case ResourceLevel.beginner:
        return 'Beginner';
      case ResourceLevel.intermediate:
        return 'Intermediate';
      case ResourceLevel.advanced:
        return 'Advanced';
      case ResourceLevel.expert:
        return 'Expert';
    }
  }

  void _openExternalResource(BuildContext context, ExternalResource resource) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text('Open External Link', style: TextStyle(color: Colors.white)),
        content: Text('You are about to visit: ${resource.url}', style: TextStyle(color: Colors.grey[300])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _launchURL(resource.url, context);
            },
            child: const Text('Open', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching URL: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class DownloadsTab extends StatelessWidget {
  const DownloadsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = Provider.of<ResourcesProvider>(context);
    final downloadedResources = resourcesProvider.downloadedResources;

    if (downloadedResources.isEmpty) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No downloads yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Download resources to access them offline',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey[900],
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: downloadedResources.length,
        itemBuilder: (context, index) {
          final resource = downloadedResources[index];
          return _DownloadedResourceCard(resource: resource);
        },
      ),
    );
  }
}

class _DownloadedResourceCard extends StatelessWidget {
  final OfflineResource resource;

  const _DownloadedResourceCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.download_done_rounded, color: Colors.white),
        ),
        title: Text(
          resource.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          '${resource.fileSize} • ${resource.category}',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: IconButton(
          onPressed: () {
            _deleteResource(context, resource);
          },
          icon: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        onTap: () {
          _openResource(context, resource);
        },
      ),
    );
  }

  void _openResource(BuildContext context, OfflineResource resource) async {
    try {
      final url = Uri.parse(resource.fileUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open ${resource.title}'),
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening resource: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteResource(BuildContext context, OfflineResource resource) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[800],
        title: const Text('Delete Resource', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${resource.title}"?', style: TextStyle(color: Colors.grey[300])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Provider.of<ResourcesProvider>(context, listen: false)
            .deleteDownloadedResource(resource);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}