import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class GuestDashboardScreen extends StatelessWidget {
  const GuestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Cybersecurity Knowledge Base', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),

            // Video Tutorials Section
            const Text(
              'Comprehensive Video Tutorials - Cybersecurity Education',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Cybersecurity Fundamentals Videos
            _buildVideoCard(
              context,
              'Cybersecurity Crash Course for Beginners',
              '2:59:25 min',
              'Complete cybersecurity fundamentals course covering threats, attacks, and defense mechanisms',
              'https://www.youtube.com/watch?v=U_P23SqJaDw',
              'FreeCodeCamp.org',
            ),
            _buildVideoCard(
              context,
              'Introduction to Cybersecurity',
              '2:18:12 min',
              'Fundamental concepts of cybersecurity, threats, and protection mechanisms',
              'https://www.youtube.com/watch?v=z5nc9MDbvkw',
              'NetworkChuck',
            ),
            _buildVideoCard(
              context,
              'Cybersecurity for Beginners',
              '3:53:36 min',
              'Complete beginner guide to understanding cybersecurity principles',
              'https://www.youtube.com/watch?v=WnN6dbos5u8',
              'Simplilearn',
            ),

            // Network Security Videos
            _buildVideoCard(
              context,
              'Network Security Fundamentals',
              '1:08:43 min',
              'Understanding network protocols, firewalls, VPNs, and network defense strategies',
              'https://www.youtube.com/watch?v=z5nc9MDbvkw',
              'PowerCert Animated Videos',
            ),
            _buildVideoCard(
              context,
              'Firewall and Network Protection',
              '45:23 min',
              'Deep dive into firewall configurations and network security architecture',
              'https://www.youtube.com/watch?v=kDEX1HXybrU',
              'ITProTV',
            ),
            _buildVideoCard(
              context,
              'Wireless Network Security',
              '38:17 min',
              'Securing WiFi networks and preventing wireless attacks',
              'https://www.youtube.com/watch?v=pdg15T-gJlM',
              'Professor Messer',
            ),

            // Cryptography Videos
            _buildVideoCard(
              context,
              'Cryptography Fundamentals',
              '1:31:12 min',
              'Complete guide to encryption, hashing, digital signatures, and cryptographic protocols',
              'https://www.youtube.com/watch?v=NuyzuNBFWxQ',
              'FreeCodeCamp.org',
            ),
            _buildVideoCard(
              context,
              'Public Key Cryptography',
              '25:48 min',
              'Understanding asymmetric encryption and digital certificates',
              'https://www.youtube.com/watch?v=GSIDS_lvRv4',
              'Computerphile',
            ),
            _buildVideoCard(
              context,
              'SSL/TLS Handshake Explained',
              '15:33 min',
              'Detailed explanation of SSL/TLS protocol and secure communications',
              'https://www.youtube.com/watch?v=cuR05y_2Gxc',
              'Practical Networking',
            ),

            // Web Application Security Videos
            _buildVideoCard(
              context,
              'Web Application Security - OWASP Top 10',
              '1:01:49 min',
              'Detailed explanation of the top 10 web application security risks and how to prevent them',
              'https://www.youtube.com/watch?v=WcateQ5zBvg',
              'Web Dev Simplified',
            ),
            _buildVideoCard(
              context,
              'SQL Injection Attacks',
              '28:35 min',
              'Understanding and preventing SQL injection vulnerabilities',
              'https://www.youtube.com/watch?v=ciNHn38EyRc',
              'Computerphile',
            ),
            _buildVideoCard(
              context,
              'Cross-Site Scripting (XSS)',
              '22:45 min',
              'Complete guide to XSS attacks and prevention techniques',
              'https://www.youtube.com/watch?v=EoaDgUgS6QA',
              'LiveOverflow',
            ),

            // Ethical Hacking Videos
            _buildVideoCard(
              context,
              'Ethical Hacking Course for Beginners',
              '13:25:51 min',
              'Complete ethical hacking course covering penetration testing and security assessment',
              'https://www.youtube.com/watch?v=3Kq1MIfTWCE',
              'FreeCodeCamp.org',
            ),
            _buildVideoCard(
              context,
              'Penetration Testing Fundamentals',
              '1:12:34 min',
              'Introduction to penetration testing methodologies and tools',
              'https://www.youtube.com/watch?v=3Kq1MIfTWCE',
              'The Cyber Mentor',
            ),
            _buildVideoCard(
              context,
              'Metasploit Framework Tutorial',
              '45:22 min',
              'Hands-on guide to using Metasploit for security testing',
              'https://www.youtube.com/watch?v=TCPyoWHy4eA',
              'Null Byte',
            ),

            // Cloud Security Videos
            _buildVideoCard(
              context,
              'Cloud Security Fundamentals',
              '1:01:36 min',
              'Understanding cloud security models, shared responsibility, and best practices',
              'https://www.youtube.com/watch?v=UhsjPTD6WrE',
              'IBM Technology',
            ),
            _buildVideoCard(
              context,
              'AWS Security Best Practices',
              '52:18 min',
              'Comprehensive guide to securing AWS cloud infrastructure',
              'https://www.youtube.com/watch?v=u9tDRJ7Oa6c',
              'AWS',
            ),
            _buildVideoCard(
              context,
              'Azure Security Center',
              '38:45 min',
              'Implementing security controls in Microsoft Azure',
              'https://www.youtube.com/watch?v=Uf9UiajC4Io',
              'Microsoft Azure',
            ),

            // Digital Forensics Videos
            _buildVideoCard(
              context,
              'Digital Forensics Fundamentals',
              '1:08:23 min',
              'Introduction to digital forensics, evidence collection, and incident response',
              'https://www.youtube.com/watch?v=2r6Y3_Qf1y4',
              'Cyberspatial',
            ),
            _buildVideoCard(
              context,
              'Computer Forensics for Beginners',
              '1:15:42 min',
              'Basic principles and tools for digital forensics investigations',
              'https://www.youtube.com/watch?v=IQqwIz1YlHU',
              'Forensics Tutorials',
            ),
            _buildVideoCard(
              context,
              'Network Forensics Analysis',
              '44:56 min',
              'Analyzing network traffic for security incidents',
              'https://www.youtube.com/watch?v=4jVXhHl3_2o',
              'SANS Institute',
            ),

            // Social Engineering Videos
            _buildVideoCard(
              context,
              'Social Engineering Attacks & Defense',
              '18:56 min',
              'Understanding psychological attacks and how to protect against social engineering',
              'https://www.youtube.com/watch?v=Vo1urF6S4u0',
              'SANS Institute',
            ),
            _buildVideoCard(
              context,
              'Phishing Attack Prevention',
              '25:34 min',
              'Identifying and preventing phishing emails and websites',
              'https://www.youtube.com/watch?v=Y7zNlEMPDm4',
              'KnowBe4',
            ),
            _buildVideoCard(
              context,
              'Human Factor in Cybersecurity',
              '32:18 min',
              'Understanding how human behavior impacts security',
              'https://www.youtube.com/watch?v=WnN6dbos5u8',
              'TEDx',
            ),

            // Mobile Security Videos
            _buildVideoCard(
              context,
              'Mobile Application Security',
              '1:11:23 min',
              'Securing mobile applications for iOS and Android platforms',
              'https://www.youtube.com/watch?v=4jVXhHl3_2o',
              'The Cyber Mentor',
            ),
            _buildVideoCard(
              context,
              'Android Security Testing',
              '47:22 min',
              'Penetration testing for Android applications',
              'https://www.youtube.com/watch?v=8T2fHcambyc',
              'Mobile Security Channel',
            ),
            _buildVideoCard(
              context,
              'iOS Security Architecture',
              '39:15 min',
              'Understanding iOS security features and implementation',
              'https://www.youtube.com/watch?v=8T2fHcambyc',
              'Apple Security',
            ),

            // Advanced Topics Videos
            _buildVideoCard(
              context,
              'Zero Trust Security Architecture',
              '15:42 min',
              'Implementing Zero Trust security models for modern enterprise protection',
              'https://www.youtube.com/watch?v=O4KGYGQvHmw',
              'Microsoft Security',
            ),
            _buildVideoCard(
              context,
              'IoT Security Challenges',
              '28:34 min',
              'Securing Internet of Things devices and networks',
              'https://www.youtube.com/watch?v=8UcUf_2T4Eo',
              'IoT Security Foundation',
            ),
            _buildVideoCard(
              context,
              'Blockchain Security',
              '35:27 min',
              'Security considerations for blockchain technology',
              'https://www.youtube.com/watch?v=Kt6uen1fS1w',
              'Blockchain Council',
            ),

            const SizedBox(height: 24),

            // Learning Paths Section
            const Text(
              'Structured Learning Paths',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildLearningPath(
              context,
              '🚀 Cybersecurity Fundamentals',
              'Start with the basics of cybersecurity',
              Colors.blue,
              [
                'Introduction to Cybersecurity',
                'Threat Landscape Overview',
                'Security Principles & Concepts',
                'Common Attack Vectors',
                'Basic Defense Mechanisms'
              ],
            ),
            _buildLearningPath(
              context,
              '🔧 Network & Infrastructure Security',
              'Protect network infrastructure and systems',
              Colors.green,
              [
                'Network Architecture Security',
                'Firewall Configuration',
                'Intrusion Detection Systems',
                'VPN & Remote Access Security',
                'Wireless Network Protection'
              ],
            ),
            _buildLearningPath(
              context,
              '🎯 Application & Data Security',
              'Secure applications and protect data',
              Colors.orange,
              [
                'Secure Coding Practices',
                'Web Application Security',
                'Database Security',
                'Cryptography Implementation',
                'API Security'
              ],
            ),
            _buildLearningPath(
              context,
              '🛡️ Cloud & Mobile Security',
              'Modern platform security',
              Colors.purple,
              [
                'Cloud Security Models',
                'Mobile App Security',
                'Container Security',
                'Serverless Security',
                'IoT Security'
              ],
            ),
            _buildLearningPath(
              context,
              '🔍 Security Operations',
              'Security monitoring and incident response',
              Colors.red,
              [
                'Security Monitoring',
                'Incident Response',
                'Digital Forensics',
                'Threat Hunting',
                'Vulnerability Management'
              ],
            ),

            const SizedBox(height: 24),

            // Comprehensive Cybersecurity Topics
            const Text(
              'Comprehensive Cybersecurity Topics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Foundation Topics
            _buildReadingCategory(
              context,
              '🔐 Security Fundamentals',
              'Core cybersecurity principles and concepts',
              Icons.security_rounded,
              Colors.blue,
              [
                'Cybersecurity Basics & Terminology',
                'Threat Intelligence & Analysis',
                'Risk Management Framework',
                'Security Governance & Compliance',
                'Security Awareness Training'
              ],
            ),

            // Network Security
            _buildReadingCategory(
              context,
              '🌐 Network Protection',
              'Network infrastructure security measures',
              Icons.wifi_rounded,
              Colors.green,
              [
                'Network Architecture & Design',
                'Firewall Technologies',
                'Intrusion Prevention Systems',
                'Network Monitoring & Analysis',
                'Secure Network Protocols'
              ],
            ),

            // Application Security
            _buildReadingCategory(
              context,
              '📱 Application Protection',
              'Secure software development practices',
              Icons.apps_rounded,
              Colors.purple,
              [
                'Secure Development Lifecycle',
                'Web Application Security',
                'Mobile App Security',
                'API Security Best Practices',
                'Vulnerability Management'
              ],
            ),

            // Data Protection
            _buildReadingCategory(
              context,
              '💾 Data Security',
              'Data protection and encryption methods',
              Icons.storage_rounded,
              Colors.amber,
              [
                'Data Classification & Handling',
                'Encryption Technologies',
                'Data Loss Prevention',
                'Database Security',
                'Backup & Recovery Strategies'
              ],
            ),

            // Incident Response
            _buildReadingCategory(
              context,
              '🚨 Incident Management',
              'Security incident response procedures',
              Icons.warning_rounded,
              Colors.red,
              [
                'Incident Response Planning',
                'Digital Forensics',
                'Malware Analysis',
                'Business Continuity',
                'Disaster Recovery'
              ],
            ),

            // Cloud Security
            _buildReadingCategory(
              context,
              '☁️ Cloud Security',
              'Cloud infrastructure protection',
              Icons.cloud_rounded,
              Colors.cyan,
              [
                'Cloud Security Models',
                'Shared Responsibility Model',
                'Cloud Compliance Standards',
                'Container Security',
                'Serverless Security'
              ],
            ),

            // Identity & Access Management
            _buildReadingCategory(
              context,
              '👤 IAM Security',
              'Identity and access management',
              Icons.person_rounded,
              Colors.teal,
              [
                'Authentication Methods',
                'Authorization Models',
                'Identity Federation',
                'Privileged Access Management',
                'Multi-Factor Authentication'
              ],
            ),

            const SizedBox(height: 24),

            // Quick Reference Guides
            const Text(
              'Quick Reference Guides',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickGuide(
              context,
              'Security Configuration Checklists',
              'Step-by-step security configuration guides',
              Icons.checklist_rounded,
            ),
            _buildQuickGuide(
              context,
              'Common Attack Patterns',
              'Recognize and defend against frequent attacks',
              Icons.warning_amber_rounded,
            ),
            _buildQuickGuide(
              context,
              'Security Tools Directory',
              'Comprehensive security tools and utilities',
              Icons.build_rounded,
            ),
            _buildQuickGuide(
              context,
              'Compliance Standards',
              'Security compliance frameworks and regulations',
              Icons.assignment_rounded,
            ),
            _buildQuickGuide(
              context,
              'Security Assessment Templates',
              'Ready-to-use security assessment templates',
              Icons.assessment_rounded,
            ),
            _buildQuickGuide(
              context,
              'Incident Response Playbooks',
              'Step-by-step incident response procedures',
              Icons.emergency_rounded,
            ),

            const SizedBox(height: 24),

            // Security Best Practices
            _buildSecurityBestPractices(),

            const SizedBox(height: 24),

            // Cybersecurity Frameworks
            _buildCybersecurityFrameworks(),

            const SizedBox(height: 24),

            // Additional Resources
            _buildAdditionalResources(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.security_rounded, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Cybersecurity Education Platform',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Access comprehensive cybersecurity educational content including video courses, tutorials, and reference materials. Learn from industry experts and build your cybersecurity knowledge. This platform provides extensive resources covering fundamental concepts to advanced security topics.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_rounded, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Professional cybersecurity educational content from industry experts',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
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

  Widget _buildVideoCard(BuildContext context, String title, String duration, String description, String videoUrl, String instructor) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 30),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey[500], size: 12),
                const SizedBox(width: 4),
                Text(instructor, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(width: 12),
                Icon(Icons.access_time, color: Colors.grey[500], size: 12),
                const SizedBox(width: 4),
                Text(duration, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.red, size: 20),
        ),
        onTap: () {
          _playVideo(context, title, videoUrl, instructor);
        },
      ),
    );
  }

  Widget _buildLearningPath(BuildContext context, String title, String subtitle, Color color, List<String> modules) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.school_rounded, color: color),
        ),
        title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
        children: [
          ...modules.map((module) => 
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Icon(Icons.ondemand_video_rounded, size: 20, color: color),
              title: Text(module, style: const TextStyle(color: Colors.white, fontSize: 14)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('Video', style: TextStyle(color: color, fontSize: 12)),
              ),
              onTap: () {
                // Navigate to video
              },
            )
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCategory(BuildContext context, String title, String subtitle, IconData icon, Color color, List<String> topics) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
        children: topics.map((topic) => 
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: Icon(Icons.article_rounded, size: 20, color: color),
            title: Text(topic, style: const TextStyle(color: Colors.white, fontSize: 14)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Read', style: TextStyle(color: Colors.blue, fontSize: 10)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Watch', style: TextStyle(color: Colors.red, fontSize: 10)),
                ),
              ],
            ),
            onTap: () {
              _showReadingContent(context, topic);
            },
          )
        ).toList(),
      ),
    );
  }

  Widget _buildQuickGuide(BuildContext context, String title, String description, IconData icon) {
    return Card(
      color: Colors.grey[800],
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.orange),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(description, style: TextStyle(color: Colors.grey[400])),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        onTap: () {
          _showQuickGuideContent(context, title);
        },
      ),
    );
  }

  Widget _buildSecurityBestPractices() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.checklist_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Essential Security Best Practices',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPracticeItem('Principle of Least Privilege', 'Grant minimum necessary access rights to users and systems', Icons.lock_rounded),
            _buildPracticeItem('Defense in Depth', 'Implement multiple layers of security controls for comprehensive protection', Icons.layers_rounded),
            _buildPracticeItem('Zero Trust Architecture', 'Never trust, always verify approach to network access', Icons.verified_user_rounded),
            _buildPracticeItem('Security by Design', 'Integrate security from initial development phases', Icons.design_services_rounded),
            _buildPracticeItem('Continuous Monitoring', 'Real-time security monitoring and alerting systems', Icons.monitor_heart_rounded),
            _buildPracticeItem('Regular Security Updates', 'Timely patching of vulnerabilities and security flaws', Icons.update_rounded),
            _buildPracticeItem('Data Encryption', 'Protect sensitive data at rest and in transit', Icons.lock_outline_rounded),
            _buildPracticeItem('Multi-Factor Authentication', 'Implement additional authentication layers', Icons.fingerprint_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildCybersecurityFrameworks() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.architecture_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Cybersecurity Frameworks & Standards',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFrameworkItem('NIST Cybersecurity Framework', 'US standard for improving critical infrastructure cybersecurity', Icons.flag_rounded),
            _buildFrameworkItem('ISO 27001/27002', 'International information security management standards', Icons.public_rounded),
            _buildFrameworkItem('CIS Controls', 'Center for Internet Security critical security controls', Icons.security_rounded),
            _buildFrameworkItem('PCI DSS', 'Payment Card Industry Data Security Standard', Icons.credit_card_rounded),
            _buildFrameworkItem('GDPR Compliance', 'European Union data protection regulation', Icons.gpp_good_rounded),
            _buildFrameworkItem('HIPAA Security Rule', 'Healthcare information protection standards', Icons.medical_services_rounded),
            _buildFrameworkItem('SOC 2 Compliance', 'Service organization control reporting', Icons.assessment_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalResources() {
    return Card(
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.library_books_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Additional Learning Resources',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildResourceItem('Cybersecurity Blogs & News', 'Stay updated with latest security trends and threats', Icons.rss_feed_rounded),
            _buildResourceItem('Security Certification Guides', 'Prepare for industry certifications like CISSP, CEH, Security+', Icons.school_rounded),
            _buildResourceItem('Security Tools Tutorials', 'Hands-on guides for popular security tools', Icons.build_rounded),
            _buildResourceItem('Security Research Papers', 'Academic and industry research publications', Icons.article_rounded),
            _buildResourceItem('Security Communities', 'Join cybersecurity forums and discussion groups', Icons.people_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeItem(String practice, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(practice, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameworkItem(String framework, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(framework, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String resource, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.purple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _playVideo(BuildContext context, String title, String videoUrl, String instructor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          title: title,
          videoUrl: videoUrl,
          instructor: instructor,
        ),
      ),
    );
  }

  void _showReadingContent(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: _getReadingContent(title),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickGuideContent(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: _getQuickGuideContent(title),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getReadingContent(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getContentTitle(title),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _getContentText(title),
          style: TextStyle(color: Colors.grey[300], fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _getQuickGuideContent(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _getQuickGuideText(title),
          style: TextStyle(color: Colors.grey[300], fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  String _getContentTitle(String title) {
    return title;
  }

  String _getContentText(String title) {
    switch (title) {
      case 'Cybersecurity Basics & Terminology':
        return '''
CYBERSECURITY FUNDAMENTALS

Core Concepts:
• Confidentiality: Protecting information from unauthorized access
• Integrity: Ensuring data accuracy and completeness
• Availability: Ensuring systems and data are accessible when needed
• Authentication: Verifying user identities
• Authorization: Granting appropriate access levels
• Non-repudiation: Preventing denial of actions

Common Threats:
• Malware: Viruses, worms, trojans, ransomware
• Phishing: Social engineering attacks via email
• DDoS: Distributed Denial of Service attacks
• Insider Threats: Malicious actions by authorized users
• Zero-day Exploits: Attacks on unknown vulnerabilities

Security Principles:
• Defense in Depth: Multiple layers of security
• Least Privilege: Minimum access required
• Separation of Duties: Divide critical tasks
• Fail-Safe Defaults: Deny access by default
• Economy of Mechanism: Keep security simple

Risk Management:
• Risk Assessment: Identify and evaluate risks
• Risk Mitigation: Implement controls
• Risk Transfer: Insurance and outsourcing
• Risk Acceptance: Business decision to accept risk

Security Controls:
• Administrative: Policies and procedures
• Technical: Technology implementations
• Physical: Physical security measures

''';
      case 'Threat Intelligence & Analysis':
        return '''
THREAT INTELLIGENCE & ANALYSIS

Threat Intelligence Types:
• Strategic: High-level business risks
• Tactical: Attack methods and TTPs
• Operational: Specific attack campaigns
• Technical: Indicators of compromise

Threat Analysis Process:
1. Collection: Gather threat data
2. Processing: Normalize and enrich data
3. Analysis: Identify patterns and trends
4. Dissemination: Share findings
5. Feedback: Improve processes

Threat Intelligence Sources:
• Open Source: Publicly available information
• Commercial: Paid threat feeds
• Internal: Organizational data
• Government: Official sources

Threat Modeling:
• STRIDE: Spoofing, Tampering, Repudiation, Information Disclosure, DoS, Elevation
• DREAD: Damage, Reproducibility, Exploitability, Affected Users, Discoverability
• PASTA: Process for Attack Simulation and Threat Analysis

Indicators of Compromise (IOCs):
• IP addresses and domains
• File hashes and signatures
• Network traffic patterns
• System and user behaviors

Threat Hunting:
• Hypothesis-driven investigations
• Proactive security monitoring
• Advanced detection techniques
• Continuous improvement

''';
      default:
        return '''
COMPREHENSIVE CYBERSECURITY KNOWLEDGE

This section provides detailed information about $title, covering essential aspects needed for comprehensive understanding and practical implementation.

Key Learning Objectives:
• Understand fundamental concepts and principles
• Learn practical implementation techniques
• Identify common challenges and solutions
• Apply best practices in real-world scenarios
• Develop security mindset and awareness
• Implement effective security controls

Professional Development:
• Continuous learning and skill development
• Industry certification preparation
• Hands-on practical experience
• Community engagement and networking
• Staying current with emerging threats

Educational Resources:
• Video tutorials and courses
• Technical documentation
• Case studies and examples
• Practical exercises and labs
• Reference materials and guides

''';
    }
  }

  String _getQuickGuideText(String title) {
    switch (title) {
      case 'Security Configuration Checklists':
        return '''
SECURITY CONFIGURATION CHECKLISTS

Operating System Hardening:
1. Disable unnecessary services and features
2. Configure proper user account controls
3. Implement strong password policies
4. Enable auditing and logging
5. Apply security patches regularly
6. Configure firewall rules
7. Enable encryption where possible
8. Remove default accounts
9. Configure security policies
10. Regular security assessments

Network Device Security:
1. Change default credentials immediately
2. Disable unused ports and services
3. Implement access control lists
4. Enable logging and monitoring
5. Regular firmware updates
6. Secure management interfaces
7. Implement network segmentation
8. Configure proper routing
9. Enable security features
10. Regular configuration reviews

Application Security:
1. Validate all input data
2. Implement proper error handling
3. Use secure authentication methods
4. Encrypt sensitive data
5. Regular security testing
6. Secure session management
7. Implement access controls
8. Security headers configuration
9. Dependency management
10. Security code review

Database Security:
1. Secure database configuration
2. Implement access controls
3. Encrypt sensitive data
4. Regular patching
5. Audit database activities
6. Backup and recovery
7. Network security
8. Application security
9. Monitoring and alerting
10. Security testing

Cloud Security:
1. Identity and access management
2. Network security controls
3. Data encryption
4. Logging and monitoring
5. Compliance configuration
6. Backup and recovery
7. Security groups
8. Resource policies
9. Security monitoring
10. Regular audits

''';
      case 'Common Attack Patterns':
        return '''
COMMON ATTACK PATTERNS & DEFENSES

Social Engineering Attacks:
• Phishing: Fraudulent emails
• Spear Phishing: Targeted phishing
• Whaling: Executive targeting
• Vishing: Voice call attacks
• Smishing: SMS text attacks
• Pretexting: Fabricated scenarios
• Baiting: Offering something enticing

Network Attacks:
• DDoS: Overwhelm resources
• Man-in-the-Middle: Intercept communications
• DNS Spoofing: Redirect traffic
• ARP Poisoning: Redirect network traffic
• Port Scanning: Discover services
• Packet Sniffing: Capture network data

Application Attacks:
• SQL Injection: Database manipulation
• Cross-Site Scripting (XSS): Execute scripts in browser
• Cross-Site Request Forgery (CSRF): Unauthorized actions
• Buffer Overflow: Memory corruption
• Input Validation: Bypass validation
• Session Hijacking: Steal sessions

Malware Types:
• Viruses: Self-replicating code
• Worms: Network spreading
• Trojans: Disguised malware
• Ransomware: Data encryption
• Spyware: Surveillance
• Adware: Advertising
• Rootkits: System hiding

Defense Strategies:
• Employee training and awareness
• Multi-layered security controls
• Regular security updates
• Network segmentation
• Access control implementation
• Monitoring and detection
• Incident response planning
• Backup and recovery

Prevention Techniques:
• Security awareness training
• Technical controls implementation
• Regular vulnerability assessments
• Security monitoring
• Access management
• Patch management
• Configuration management
• Security testing

''';
      default:
        return '''
QUICK REFERENCE GUIDE: $title

This quick reference provides essential information and best practices for $title. Use this guide for quick consultations and as a reminder of key security principles.

Key Features:
• Concise information presentation
• Actionable recommendations
• Best practice guidelines
• Common scenarios covered
• Quick implementation tips

Usage Guidelines:
• Regular review and updates
• Team training reference
• Implementation checklist
• Compliance verification
• Security assessment aid

Additional Resources:
• Detailed documentation
• Video tutorials
• Practical examples
• Community forums
• Expert consultations

Professional Development:
• Certification preparation
• Skill enhancement
• Knowledge expansion
• Career advancement
• Industry recognition

''';
    }
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoUrl;
  final String instructor;

  const VideoPlayerScreen({
    super.key,
    required this.title,
    required this.videoUrl,
    required this.instructor,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.grey,
      ),
      placeholder: Container(
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : Chewie(controller: _chewieController!),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Instructor: ${widget.instructor}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getVideoDescription(widget.title),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getVideoDescription(String title) {
    switch (title) {
      case 'Cybersecurity Crash Course for Beginners':
        return 'Complete cybersecurity fundamentals course covering threats, attacks, and defense mechanisms. Perfect for beginners starting their cybersecurity journey. Learn essential concepts and build strong foundation.';
      case 'Introduction to Cybersecurity':
        return 'Fundamental concepts of cybersecurity, threats, and protection mechanisms. Understand the cybersecurity landscape and basic security principles.';
      case 'Cybersecurity for Beginners':
        return 'Complete beginner guide to understanding cybersecurity principles, common threats, and basic protection strategies. Start your security education.';
      case 'Network Security Fundamentals':
        return 'Understanding network protocols, firewalls, VPNs, and network defense strategies for protecting network infrastructure and communications.';
      case 'Firewall and Network Protection':
        return 'Deep dive into firewall configurations, network security architecture, and advanced network protection techniques for enterprise environments.';
      case 'Wireless Network Security':
        return 'Securing WiFi networks, preventing wireless attacks, and implementing robust wireless security measures for home and enterprise networks.';
      case 'Cryptography Fundamentals':
        return 'Complete guide to encryption, hashing, digital signatures, and cryptographic protocols for data protection and secure communications.';
      case 'Public Key Cryptography':
        return 'Understanding asymmetric encryption, digital certificates, public key infrastructure (PKI), and cryptographic key management.';
      case 'SSL/TLS Handshake Explained':
        return 'Detailed explanation of SSL/TLS protocol, secure communications establishment, and cryptographic handshake processes.';
      case 'Web Application Security - OWASP Top 10':
        return 'Detailed explanation of the top 10 web application security risks and how to prevent them with practical examples and real-world scenarios.';
      case 'SQL Injection Attacks':
        return 'Understanding SQL injection vulnerabilities, attack techniques, prevention methods, and secure coding practices for database security.';
      case 'Cross-Site Scripting (XSS)':
        return 'Complete guide to XSS attacks, vulnerability types, exploitation techniques, and comprehensive prevention strategies.';
      case 'Ethical Hacking Course for Beginners':
        return 'Complete ethical hacking course covering penetration testing, vulnerability assessment, security testing methodologies, and legal considerations.';
      case 'Penetration Testing Fundamentals':
        return 'Introduction to penetration testing methodologies, tools, techniques, and professional security assessment practices.';
      case 'Metasploit Framework Tutorial':
        return 'Hands-on guide to using Metasploit for security testing, vulnerability exploitation, and penetration testing exercises.';
      case 'Cloud Security Fundamentals':
        return 'Understanding cloud security models, shared responsibility, compliance requirements, and best practices for cloud infrastructure protection.';
      case 'AWS Security Best Practices':
        return 'Comprehensive guide to securing AWS cloud infrastructure, implementing security controls, and following AWS security best practices.';
      case 'Azure Security Center':
        return 'Implementing security controls in Microsoft Azure, using Azure Security Center, and following Microsoft cloud security guidelines.';
      case 'Digital Forensics Fundamentals':
        return 'Introduction to digital forensics, evidence collection, incident response procedures, forensic analysis techniques, and legal considerations.';
      case 'Computer Forensics for Beginners':
        return 'Basic principles, tools, and methodologies for digital forensics investigations, evidence handling, and forensic analysis.';
      case 'Network Forensics Analysis':
        return 'Analyzing network traffic, identifying security incidents, conducting network forensics, and using network forensic tools.';
      case 'Social Engineering Attacks & Defense':
        return 'Understanding psychological attacks, social engineering techniques, human behavior manipulation, and developing effective human-layer security defenses.';
      case 'Phishing Attack Prevention':
        return 'Identifying and preventing phishing emails, malicious websites, social engineering attacks, and implementing anti-phishing measures.';
      case 'Human Factor in Cybersecurity':
        return 'Understanding how human behavior, psychology, and organizational culture impact security effectiveness and vulnerability.';
      case 'Mobile Application Security':
        return 'Securing mobile applications for iOS and Android platforms, mobile security architecture, and protection against mobile-specific threats.';
      case 'Android Security Testing':
        return 'Penetration testing for Android applications, mobile app security assessment, and Android platform security features.';
      case 'iOS Security Architecture':
        return 'Understanding iOS security features, Apple security implementation, iOS app security, and mobile device protection.';
      case 'Zero Trust Security Architecture':
        return 'Implementing Zero Trust security models, micro-segmentation, identity verification, and continuous security validation for modern enterprise environments.';
      case 'IoT Security Challenges':
        return 'Securing Internet of Things devices, networks, and platforms against emerging IoT security threats and vulnerabilities.';
      case 'Blockchain Security':
        return 'Security considerations, threats, and protection strategies for blockchain technology, cryptocurrencies, and distributed ledger systems.';
      default:
        return 'Professional cybersecurity educational content covering essential concepts, practical techniques, and industry best practices with expert instruction and real-world examples.';
    }
  }
}