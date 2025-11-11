import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  // Use localhost since IP isn't accessible
  static const String _backendBaseUrl = 'http://localhost:5000/api';

  static Future<String> getAIResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendBaseUrl/ai/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['success'] == true) {
          return data['response'];
        } else {
          throw Exception('AI service error: ${data['error']}');
        }
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Cannot connect to server. Make sure the backend is running on localhost:5000');
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }
}