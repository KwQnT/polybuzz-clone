import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatApi {
  static const String _apiKey = String.fromEnvironment('CHUTES_KEY', defaultValue: '');
  static const String _baseUrl = 'https://llm.chutes.ai/v1/chat/completions';
  static const String _model = 'unsloth/Mistral-Nemo-Instruct-2407-TEE';

  static Future<String> sendMessage(List<Map<String, String>> messages) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.9,
          'max_tokens': 800,
        }),
      );

      if (response.statusCode != 200) {
        return 'Ошибка ${response.statusCode}: ${response.body}';
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final choices = data['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        return 'Пустой ответ от модели';
      }
      return choices[0]['message']['content']?.toString() ?? '';
    } catch (e) {
      return 'Ошибка: $e';
    }
  }
}
